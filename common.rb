require "json"
require 'active_record'

#標準出力をバッファリングしない
STDOUT.sync = true

if `hostname -f`.include?("local")
  host = 'localhost'
  user = 'root'
  pass = ""
  ActiveRecord::Base.logger = Logger.new(STDOUT) unless ARGV.include?('silent')
end

# DB接続設定
ActiveRecord::Base.establish_connection(
  adapter:   'mysql2',
  encoding:  'utf8mb4',
  charset:   'utf8mb4',
  collation: 'utf8mb4_general_ci',
  database:  "instagram_restaurants_collector",
  host:      host,
  username:  user,
  password:  pass
)

# テーブルにアクセスするためのクラスを宣言
class TopRestaurant < ActiveRecord::Base
end