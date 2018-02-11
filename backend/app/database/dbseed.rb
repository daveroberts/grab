require 'uri'
require 'json'
require './app/database/database.rb'
require './app/lib/data_mapper.rb'

# Adds a demo data set to the database
class DBSeed
  @scrapes = [
    {
      id: '4a990719-1862-4fa2-b5f1-e26c8867faec',
    },
  ]
  @tags = [
  ]
  def self.seed
    puts 'Seeding database'
    @scrapes.each do |scrape|
      values = {
        id: scrape[:id],
        created_at: DateTime.now
      }
      DataMapper.insert("scrapes", values)
    end
    puts "Added #{@scrapes.count} scrapes"
    puts 'Done seeding DB'
  end
end
