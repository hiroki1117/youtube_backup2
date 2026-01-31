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

# ACL設定を分離
resource "aws_s3_bucket_acl" "youtubedl_bucket_acl" {
  bucket = aws_s3_bucket.youtubedl_bucket.id
  acl    = "private"
}

# ライフサイクル設定を分離
resource "aws_s3_bucket_lifecycle_configuration" "youtubedl_bucket_lifecycle" {
  bucket = aws_s3_bucket.youtubedl_bucket.id

  rule {
    id     = "intelligent-tiering"
    status = "Enabled"

    transition {
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}
