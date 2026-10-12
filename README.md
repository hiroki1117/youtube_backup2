# YoutubeBackup2

> [!IMPORTANT]
> このリポジトリの基盤更新は停止しました。2026-10-11にTerraform基盤の移管を完了し、現在の管理先は [hiroki1117/infra の youtube-backup/prod](https://github.com/hiroki1117/infra/tree/main/youtube-backup/prod) です。
> 旧コード・変更履歴の参照用として保持します。この配置でTerraformを実行したり、停止済みの旧plan/apply CIを再開したりしないでください。同じ基盤/stateを移管先と二重管理し、本番への変更が競合するためです。

`youtube_backup2` は旧基盤用repoです。稼働中の旧Lambda/APIは [youtube-backup](https://github.com/hiroki1117/youtube-backup) 側の旧アプリstate（key `youtube-dl`）に残り、このrepoの更新停止で停止・削除するものではありません。アプリの改修先 [youtube-backup-v2](https://github.com/hiroki1117/youtube-backup-v2) も別repoで、本番切替は別工程です。[移管先の管理境界](https://github.com/hiroki1117/infra/blob/main/youtube-backup/README.md)を参照してください。

以下は移管前の責務です。

## 概要
動画データを保存するストレージを定義
変更サイクルが緩やかなインフラを準備する

## 責務
- ストレージの定義
- コンピューティングリソース準備
- IAM

## 責務外
- バックアップ処理の実装や実行
- lambda定義


