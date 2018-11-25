# DB設計
Integerはdefault 0, Booleanはdefault falseに統一

## Users - ユーザーテーブル
  - id:integer - ID
  - name:string - 名前
  - display_name:string - メンション名
  - mail:string - メール
  - phone:string - 電話番号
  - password周り

## Tweets - ツイートテーブル
  - id:integer - ID
  - text:text - テキスト
  - user_id:integer - ユーザーID

## Tweet_images - 画像テーブル
  - id:integer - ID
  - image:???? - 画像
  - tweet_id:integer - ツイートID
※1つのツイートにつき最大画像4つまで

## User_follows - フォローテーブル
  - id:integer - ID
  - user_id:integer - ユーザーID
  - follow_id:integer - フォローID(フォロー先のユーザーID)
