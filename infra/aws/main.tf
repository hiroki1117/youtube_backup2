terraform {
  required_version = ">= 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.30"
    }
  }

  backend "s3" {
    bucket = "hiroki1117-tf-state"
    key    = "youtube-backup2" # 新しいキー（旧: youtube-dl）
    region = "ap-northeast-1"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
