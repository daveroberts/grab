require "sinatra"
require './app/browser/chrome.rb'

# run_controller.rb
class App < Sinatra::Application

  post "/run/links/?" do
    params = JSON.parse(request.body.read, symbolize_names: true)
    chrome = Chrome.new
    chrome.go_to_url(params[:url])
    links = chrome.links
    return links.to_json
  end

end
