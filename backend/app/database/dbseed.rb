require 'uri'
require 'json'
require './app/database/database.rb'
require './app/lib/data_mapper.rb'

# Adds a demo data set to the database
class DBSeed
  @scrapes = [
    {
      id: '4a990719-1862-4fa2-b5f1-e26c8867faec',
      name: "Hello World"
    },
    {
      id: '44bee2b5-7c84-419b-b022-a6e8c155aa72',
      name: "Testing 1,2,3"
    },
  ]
  @tags = [
  ]
  def self.seed
    puts 'Seeding database'
    @scrapes.each do |scrape|
      values = {
        id: scrape[:id],
        name: scrape[:name],
        created_at: DateTime.now
      }
      DataMapper.insert("scrapes", values)
    end
    puts "Added #{@scrapes.count} scrapes"
    puts 'Done seeding DB'
  end
end
