require 'securerandom'

class InvalidScrape < StandardError
  attr_reader :error
  def initialize(error)
    @error = error
  end
end

# manages scrapes in database
class Scrape

  @@traces = {}

  def self.columns
    [
      :id,
      :name,
      :url,
      :pattern,
      :mappings,
      :created_at
    ]
  end

  def self.all
    sql = "SELECT
  #{Scrape.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")}
FROM scrapes s
ORDER BY s.`name`"
    rows = DataMapper.select(sql, {
      prefix: 's',
      has_many: [
      ]
    })
    rows
  end

  def self.find(id)
    sql = "SELECT
  #{Scrape.columns.map{|c|"s.`#{c}` as s_#{c}"}.join(",")}
FROM scrapes s
WHERE s.id = ?
"
    rows = DataMapper.select(sql, {
      prefix: 's',
      has_many: [
      ]
    }, id)
    return nil if rows.count == 0
    rows.first
  end

  def self.scrape_to_fields(scrape)
    return {
      id:         scrape[:id],
      name:       scrape[:name],
      url:        scrape[:url],
      pattern:    scrape[:pattern],
      mappings:   scrape[:mappings].to_json,
      created_at: scrape[:created_at]?Time.new(scrape[:created_at]):nil
    }
  end

  def self.update(scrape)
    fields = scrape_to_fields scrape
    DataMapper.update('scrapes', fields)
    return scrape
  end

  def self.insert(scrape)
    scrape[:id] = SecureRandom.uuid unless scrape[:id]
    scrape[:created_at] = Time.now.to_s unless scrape[:created_at]
    fields = scrape_to_fields scrape
    DataMapper.insert('scrapes', fields)
    return scrape
  end

end
