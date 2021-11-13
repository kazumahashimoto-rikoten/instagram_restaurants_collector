require 'selenium-webdriver'
class SeleniumHelper
  attr_accessor :session

  def initialize()
    ua = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36"
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-setuid-sandbox")
    options.add_argument("--disable-gpu")
    options.add_argument("--user-agent=#{ua}")
    options.add_argument("window-size=1280x800")
    options.add_argument("--disable-popup-blocking")
    client = Selenium::WebDriver::Remote::Http::Default.new
    @session = Selenium::WebDriver.for :chrome, options: options, http_client: client
    @session.manage.timeouts.implicit_wait = 300
  end

  def navigate_to(url)
    @session.navigate.to(url)
  end

  def execute_script(js_script)
    @session.execute_script(js_script)
  end

  def elements_click(css_selector)
    js_script = %Q{document.querySelector("#{css_selector}").click()}
    execute_script(js_script)
  end

  def switch_frame(*css_selectors)
    @session.switch_to.window @session.window_handle
    css_selectors.each do |css_selector|
      iframe = @session.find_element(:css,css_selector)
      @session.switch_to.frame(iframe)
    end
  end

  def css_exist?(css_selector)
    rescue_session = @session
    rescue_session.manage.timeouts.implicit_wait = 5
    rescue_session.find_elements(:css,css_selector).present?
  end

  def send_value(css_selector,value)
    js_script = %Q{document.querySelector("#{css_selector}").value = "#{value}"}
    execute_script(js_script)
  end
end