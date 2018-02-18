require 'selenium-webdriver'
require 'securerandom'

class Chrome
  
  def self.get_links(url)
    
  end
 
  def initialize(trace=[])
    @trace = trace
  end

  def go_to_url(url)
    begin
      @trace.push({ summary: "Navigating to #{url}", level: :info, timestamp: Time.now })
      driver.get(url)
      sleep 1
      return true
    rescue # usually a bad URL
      @trace.push({ summary: "Could not navigate to #{url}", level: :warn, timestamp: Time.now })
      return false
    end
  end

  def element(selector)
    begin
      return driver.find_element(selector)
    rescue Selenium::WebDriver::Error::NoSuchElementError => e
      @trace.push({ summary: "No such element found for #{selector}", level: :warn, timestamp: Time.now })
      return nil
    end
  end

  def click(element)
    if element
      @trace.push({ summary: "Clicking element", details: "Element #{element_to_s(element)}", show_details: false, level: :info, timestamp: Time.now })
      element.click()
      sleep 2
      wait_for_load()
      sleep 2
    else
      @trace.push({ summary: "Tried to click an element which doesn't exist", level: :error, timestamp: Time.now })
    end
  end

  def wait_for_load()
    wait = Selenium::WebDriver::Wait.new(:timeout => 60) # seconds
    count = 0
    begin
      wait.until do
        state = driver.execute_script('var browserState = document.readyState; return browserState;')
        puts state
        state == "complete"
      end
    rescue Timeout::Error
    end
  end

  def fill_in_textbox(element, data)
    @trace.push({ summary: "Typing `#{data}` into form", details: "Typed data `#{data}` into #{element_to_s(element)}", show_details: false, level: :info, timestamp: Time.now })
    element.send_keys(data)
  end

  def submit_form(element)
    element.submit
  end

  def text_from_element(element)
    element.text
  end

  def screenshot()
    filename = SecureRandom.uuid
    filepath = "/tmp/#{filename}.png"
    driver.save_screenshot(filepath)
    data = File.read(filepath)
    File.delete(filepath)
    image_id = ImageItem.save(data, "picture")
    @trace.push({ summary: "Taking screenshot", level: :info, image_id: image_id, show_image: true, timestamp: Time.now })
    return {
      image_id: image_id,
      data: data
    }
  end

  def html()
    driver.execute_script("return document.documentElement.outerHTML")
  end

  def page_source()
    driver.page_source
  end

  def links()
    anchors = driver.find_elements({ tag_name: 'a'})
    links = anchors.map{|a|a.attribute(:href)}
    @trace.push({ summary: "Found (#{links.length}) links on the page", level: :info, tables: [{
      title: "Links Found",
      headers: [
        { name: "URL", type: "string" }
      ],
      rows: links.map{|l| [{ value: l }] }
    }],
    show_tables: false,
    timestamp: Time.now })
    return links
  end

  def wait(seconds=5)
    sleep seconds
  end

  private

  def driver
    return @wd if @wd
    @trace.push({ summary: "Starting Chrome", level: :info, timestamp: Time.now })
    options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])
    @wd = Selenium::WebDriver.for(:chrome, options: options)
    @wd.manage.window.resize_to(1920, 1080)
    return @wd
  end

  def element_to_s(element)
    return "(null)" if !element
    id = ""
    id = "##{element.attribute("id")}" if element.attribute("id")
    classname = ""
    classname = element.attribute("class").split.map{|c|".#{c}"}.join("") if element.attribute("class") if element.attribute("class")
    name = ""
    name = "[name=#{element.attribute("name")}]" if element.attribute("name")
    "#{element.tag_name}#{id}#{classname}#{name}".strip
  end

end
