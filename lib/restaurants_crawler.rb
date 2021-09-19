require "json"
require_relative '../../selenium_helper'

class RestaurantsCrawler < SeleniumHelper
  def initialize()
    super()
  end

  def login_instagram()
    insta_url = "https://www.instagram.com/"
    navigate_to(insta_url)
    user_name = ENV["INSTA_NAME"]
    pass_word = ENV["INSTA_PASS"]
    send_value('input[name="username"]', user_name)
    send_value('input[name="password"]', pass_word)
    query_click("button[type='submit']")
    #画面読み込み(仕様未定)
  end

  def search_restaurants()
    stations = ["大崎", "五反田", "目黒", "恵比寿", "渋谷", "原宿", "代々木", "新宿", "新大久保", "高田馬場", "目白", "池袋", "大塚", "巣鴨", "駒込", "田端", "西日暮里", "日暮里", "鶯谷", "上野", "御徒町", "秋葉原", "神田", "東京", "有楽町", "新橋", "浜松町", "田町", "高輪ゲートウェイ", "品川"]
    stations.each do |station|
      navigate_to("https://www.instagram.com/explore/tags/#{station}ランチ/")
      #画面読み込み(仕様未定)
      #popular_store = execute_script('document.querySelectorAll("div.EZdmt a")')#各投稿に遷移する時はこのaタグ
      post_data = execute_script("window._sharedData")
      post_data_json = Json.parse(post_data)
  end
end

crawler = RestaurantsCrawler.new
crawler.login_instagram()
crawler.search_restaurants()