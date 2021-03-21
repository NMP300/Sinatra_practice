# Sinatra practice
## 概要
このリポジトリは FjordBootCamp の Sinatara プラクティスの提出物です。  
Sinatra を利用したメモアプリになります。作成したメモは `memos/`配下にjsonファイルとして保存されます。

## セットアップ

以下で Sinatra をインストールしてください。
```shell
gem install sinatra
gem install sinatra-contrib
```

次に gem をインストールしてください。
```shell
bundle install
```

以下でサーバーを立ち上げ http://localhost:4567/memos/ にアクセスできれば、セットアップ完了です。
```shell
ruby app.rb
```

