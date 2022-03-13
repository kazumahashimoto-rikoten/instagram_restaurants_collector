# instagram_restaurants_collector

目的  
insta restaurants (http://13.114.155.169/) のレストラン情報の収集

方法  
"駅名"ランチでハッシュタグ検索し、上位のレストラン情報をパース

環境構築
```
bundle install
set INSTA_NAME= #instagram_id
set INSTA_PASS= #instagram_password
```

実行
```
bundle exec ruby lib/restaurants_crawler.rb
```