# このサービスについて

ポッドキャスト「桐生あんず電波局」の RSS フィードを配信するために作られた個人 Web サービスです。

配信用RSSフィードURL: https://anzucast.com/episode/rss

## 使用フレームワーク

- Rails 8
  - 本番DB は sqlite を使用
- Tailwind CSS

## ローカルでの起動方法

```bash
bin/dev
# ./Procfile.dev でrails serverコマンドとライブリビルドプロセスの両方を実行
```
