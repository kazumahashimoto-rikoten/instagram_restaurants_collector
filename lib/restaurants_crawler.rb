require_relative '../../selenium_helper'

class RestaurantsCrawler < SeleniumHelper
  def initialize()
    super()
  end

  def login_instagram()
  end

  def search_restaurants()
  end
end

crawler = RestaurantsCrawler.new
crawler.login_instagram()
crawler.search_restaurants()