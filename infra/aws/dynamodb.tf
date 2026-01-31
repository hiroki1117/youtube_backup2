# DynamoDB Table
resource "aws_dynamodb_table" "youtube_backup_table" {
  name           = "YoutubeBackup"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "video_id"

  attribute {
    name = "video_id"
    type = "S"
  }

  attribute {
    name = "upload_status"
    type = "S"
  }

  attribute {
    name = "backupdate"
    type = "S"
  }

  global_secondary_index {
    name            = "upload_status-backupdate-index"
    hash_key        = "upload_status"
    range_key       = "backupdate"
    projection_type = "ALL"
  }

  tags = {
    Product = "youtube-dl"
  }
}

# AWS Backup設定
resource "aws_backup_vault" "vault" {
  name = "youtube-backup-vault"
}

resource "aws_backup_plan" "plan" {
  name = "youtube-backup-plan"

  rule {
    rule_name         = "daily_backup"
    target_vault_name = aws_backup_vault.vault.name
    schedule          = "cron(0 3 * * ? *)"  # 毎日12:00 JST

    lifecycle {
      delete_after = 35
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "BackupRole" {
  name = "BackupRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backup_policy" {
  role       = aws_iam_role.BackupRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}

resource "aws_backup_selection" "selection" {
  name         = "youtube-backup-selection"
  plan_id      = aws_backup_plan.plan.id
  iam_role_arn = aws_iam_role.BackupRole.arn

  resources = [
    aws_dynamodb_table.youtube_backup_table.arn
  ]
}
