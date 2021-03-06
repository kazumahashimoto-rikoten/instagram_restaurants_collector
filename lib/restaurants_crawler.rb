require_relative '../common'
require_relative '../selenium_helper'
require 'pry'

class RestaurantsCrawler < SeleniumHelper
  def initialize()
    super()
  end

  def login_instagram(test = true)
    crawl_test() if test == true
    insta_url = "https://www.instagram.com/"
    sleep 1
    navigate_to(insta_url)
    #画面読み込み(仕様未定)
    raise unless css_exist?("input[aria-label]")
    user_name = ENV["INSTA_NAME"]
    pass_word = ENV["INSTA_PASS"]
    @session.find_element(:css, "input[name='username']").send_keys(user_name)
    @session.find_element(:css, "input[name='password']").send_keys(pass_word)
    sleep 10
    elements_click("button[type='submit']")
    #画面読み込み(仕様未定)
    raise unless css_exist?("input[aria-label]")
  end

  def search_restaurants()
    stations = ["大崎", "五反田", "目黒", "恵比寿", "渋谷", "原宿", "代々木", "新宿", "新大久保", "高田馬場", "目白", "池袋", "大塚", "巣鴨", "駒込", "田端", "西日暮里", "日暮里", "鶯谷", "上野", "御徒町", "秋葉原", "神田", "東京", "有楽町", "新橋", "浜松町", "田町", "高輪ゲートウェイ", "品川"]
    stations.each do |station|
      sleep 1
      navigate_to("https://www.instagram.com/explore/tags/#{station}ランチ/")
      #画面読み込み(仕様未定)
      sleep 10
      raise unless css_exist?(".Saeqz")
      #popular_store = execute_script('document.querySelectorAll("div.EZdmt a")')#各投稿に遷移する時はこのaタグ
      post_data = execute_script("return window._sharedData")
      sections = post_data.dig("entry_data", "TagPage", 0, "data", "top", "sections")
      sections.each do |section|
        medias = section.dig("layout_content", "medias")
        medias.each do |media|
          media_parser(media, station)
        end
      end
    end
  end

  def media_parser(media, station)
    detail_post_code = media["media"]["code"]#https://www.instagram.com/p/#{detail_post_code}/で詳細ページ
    store_location = media.dig("media", "location")

    address = store_location&.[]("address")
    city = store_location&.[]("city")
    external_source = store_location&.[]("external_source")
    facebook_places_id = store_location&.[]("facebook_places_id")
    lat = store_location&.[]("lat")#東京か判定に使用
    lng = store_location&.[]("lng")#東京か判定に使用
    name = store_location&.[]("name")
    pk = store_location&.[]("pk")#https://www.instagram.com/explore/locations/#{pk}/でお店の投稿一覧
    short_name = store_location&.[]("short_name")

    poster_full_name = media.dig("media", "user", "full_name")
    poster_user_name = media.dig("media", "user", "username")

    restaurant = TopRestaurant.find_or_initialize_by(post_code: detail_post_code)
    if restaurant.new_record?
      restaurant.update({
        :restaurant_name => name,
        :short_name => short_name,
        :pk => pk,
        :post_url => "https://www.instagram.com/p/#{detail_post_code}/",
        :station => station,
        :address => address,
        :city => city,
        :external_source => external_source,
        :facebook_places_id => facebook_places_id,
        :lat => lat,
        :lng => lng,
        :poster_full_name => poster_full_name,
        :poster_username => poster_user_name,
      })
    end
  end

  def crawl_test()
    url = "https://www.waseda.jp/top/"
    sleep 1
    navigate_to(url)
    p css_exist?("title")
    p 0
    sleep 10
    exit
  end
end

crawler = RestaurantsCrawler.new
crawler.login_instagram(false)
sleep 10
crawler.search_restaurants()