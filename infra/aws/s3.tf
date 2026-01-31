# S3 Bucket（基本設定のみ）
resource "aws_s3_bucket" "youtubedl_bucket" {
  bucket = "youtubedl-bucket"

  tags = {
    Product = "youtube-dl"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Bucket Ownership Controls（ACL無効化）
resource "aws_s3_bucket_ownership_controls" "youtubedl_bucket_ownership" {
  bucket = aws_s3_bucket.youtubedl_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# パブリックアクセスブロック設定
resource "aws_s3_bucket_public_access_block" "youtubedl_bucket_pab" {
  bucket = aws_s3_bucket.youtubedl_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# サーバー側暗号化設定（明示的に設定）
resource "aws_s3_bucket_server_side_encryption_configuration" "youtubedl_bucket_encryption" {
  bucket = aws_s3_bucket.youtubedl_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# ライフサイクル設定を分離
resource "aws_s3_bucket_lifecycle_configuration" "youtubedl_bucket_lifecycle" {
  bucket = aws_s3_bucket.youtubedl_bucket.id

  rule {
    id     = "intelligent-tiering"
    status = "Enabled"

    transition {
      days          = 0
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}

# バージョニング設定（オプション：誤削除対策として有効化を推奨）
resource "aws_s3_bucket_versioning" "youtubedl_bucket_versioning" {
  bucket = aws_s3_bucket.youtubedl_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}
