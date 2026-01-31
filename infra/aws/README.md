# YouTube Backup Infrastructure

## 概要

YouTube動画バックアップシステムのAWSインフラ構成です。

## 環境構築

### 前提条件

- Terraform >= 1.14.0

### 初回セットアップ

1. 設定ファイルをコピー

```bash
cd infra/aws
cp terraform.tfvars.example terraform.tfvars
```

2. `terraform.tfvars`を編集してAWSプロファイル名を設定

```hcl
aws_profile = "your-profile-name"
```

3. Terraformの初期化と適用

```bash
terraform init
terraform plan
terraform apply
```

## 詳細仕様

TODO: 後で追加
