require 'selenium_webdriver'
class SeleniumHelper
  attr_accessor :session

  def initialize()
    ua = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.116 Safari/537.36"
    caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {args: ["--headless","--no-sandbox", "--disable-setuid-sandbox", "--disable-gpu", "--user-agent=#{ua}", 'window-size=1280x800']})
    client = Selenium::WebDriver::Remote::Http::Default.new
    @session = Selenium::WebDriver.for :chrome, desired_capabilities: caps, http_client: client
    @session.manage.timeouts.implicit_wait = 1
  end

  def navigate_to(url)
    @session.navigate_to(url)
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