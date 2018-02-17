require "sinatra"

# scrape_controller.rb
class App < Sinatra::Application
  get "/scrapes/?" do
    return Scrape.all.to_json
  end

  get "/scrapes/:id/?" do
    return Scrape.find(params[:id]).to_json
  end

  post "/scrapes/?" do
    scrape = JSON.parse(request.body.read, symbolize_names: true)
    begin
      Scrape.save(scrape)
      return { scrape: scrape }.to_json
    rescue Exception => e
      return [500, e]
    end
  end
  
end
