# /review-aws-tf

infra/aws ディレクトリのTerraformコードをレビューする。

## 実行手順

1. `infra/aws/` 配下の全 `.tf` ファイルを読み込む
2. 以下の観点でレビューを実施する

---

## レビュー観点

### 責務チェック（最重要）

このディレクトリの責務は **YouTube動画バックアップシステムのAWSインフラ管理** である。

**管理対象リソース:**
- S3バケット（youtubedl-bucket）: 動画ファイル保存
- DynamoDB（YoutubeBackup）: 動画メタデータ管理
- AWS Backup: DynamoDBのバックアップ
- IAM Role（GitHubActionsOIDCRole）: CI/CD用

**責務外（以下が含まれていたら違反）:**
- Lambda, ECS, EC2等のコンピュートリソース
- VPC, サブネット, セキュリティグループ
- CloudFront, API Gateway
- 他プロジェクトのリソース

### Terraformベストプラクティス

- リソース名は `snake_case` で統一されているか
- 全リソースに `Product` タグが付与されているか
- 重要リソースに `lifecycle.prevent_destroy = true` があるか
- ハードコードされた値は変数化されているか
- `terraform fmt` に準拠しているか

### AWSセキュリティ

**S3:**
- `aws_s3_bucket_public_access_block` で全ブロック有効か
- `aws_s3_bucket_server_side_encryption_configuration` が設定されているか
- バージョニングが有効か

**DynamoDB:**
- バックアップ設定があるか（AWS Backup or PITR）

**IAM:**
- 最小権限の原則に従っているか
- `Resource: "*"` の使用は読み取り専用アクションのみか
- OIDC条件が適切に設定されているか

### コスト最適化

- S3ライフサイクルポリシーが設定されているか
- DynamoDBの課金モードが適切か
- 不要なリソースがないか

---

## 出力形式

以下の形式でレビュー結果を出力する：

```
## infra/aws レビュー結果

### 責務チェック
- [ ] 責務内リソースのみ: (OK/NG)
- 違反リソース: (あれば記載)

### Terraformベストプラクティス
| 項目 | 状態 | 備考 |
|------|------|------|
| 命名規則 | OK/NG | |
| タグ付け | OK/NG | |
| prevent_destroy | OK/NG | |
| 変数化 | OK/NG | |
| fmt準拠 | OK/NG | |

### セキュリティ
| リソース | 項目 | 状態 |
|----------|------|------|
| S3 | パブリックアクセスブロック | OK/NG |
| S3 | 暗号化 | OK/NG |
| S3 | バージョニング | OK/NG |
| DynamoDB | バックアップ | OK/NG |
| IAM | 最小権限 | OK/NG |

### コスト最適化
| 項目 | 状態 | 備考 |
|------|------|------|
| S3ライフサイクル | OK/NG | |
| DynamoDB課金 | OK/NG | |

### 改善提案
1. (具体的な改善案)
2. ...

### 総合評価: A/B/C/D
- A: 問題なし
- B: 軽微な改善点あり
- C: 要改善
- D: 重大な問題あり
```
