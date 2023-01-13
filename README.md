# memo_app

`memo_app`はSinatraで作成したメモアプリです。

## バージョン

- Ruby:3.1.2
- Bundler:2.3.16

## インストール

1. 以下コマンドを実行し、Gemfileを作成します。
```
$ mkdir memo_app
$ cd memo_app
$ bundle init
```

2. Gemfileに以下を記載します。
```
gem 'sinatra'
gem 'webrick'
gem 'sinatra-contrib'
```

3. 以下コマンドを実行し、記載したGemをインストールします。
```
$ bundle install
```

## 使用方法

1. 以下のコマンドを実行し、メモアプリを起動します。
```
$ ruby memo.rb
```

2. ブラウザで以下のURLに接続します。
```
http://localhost:4567
```
