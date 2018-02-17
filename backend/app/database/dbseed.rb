require 'uri'
require 'json'
require './app/database/database.rb'
require './app/lib/data_mapper.rb'
require './app/models/scrape.rb'

# Adds a demo data set to the database
class DBSeed
  @scrapes = [
    {
      id: '4a990719-1862-4fa2-b5f1-e26c8867faec',
      name: "Keenertech",
      url: "http://www.keenertech.com/",
      pattern: '^https?:\/\/www\.keenertech\.com\/\d+\/\d+\/.+\/$',
      mappings: "[]",
    },
  ]
  @tags = [
  ]
  def self.seed
    puts 'Seeding database'
    @scrapes.each do |scrape|
      Scrape.insert(scrape)
    end
    puts "Added #{@scrapes.count} scrapes"
    puts 'Done seeding DB'
  end
end
