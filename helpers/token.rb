require 'securerandom'
require 'rest-client'

class Token

  attr_accessor :name, :link, :rarity, :slot, :exchange_points
  attr_reader :image_guid, :classes, :years, :exchanges_to, :sources

  def initialize
    @name = ''
    @link = ''
    @image_full = ''
    @image_guid = ''
    @classes = []
    @rarity = ''
    @slot = ''
    @years = []
    @exchange_points = ''
    @exchanges_to = []
    @sources = []
  end

  def setup_token_image(image_url)
    @image_full = image_url
    extension = '.jpg'
    @image_guid = "#{SecureRandom.uuid.gsub('-', '').upcase}#{extension}"
  end

  def download_token_image(directory)
    File.write("#{directory}/#{@image_guid}", RestClient.get(@image_full).body, mode: 'wb')
  end

  def add_class(td_class)
    @classes << td_class
  end

  def add_classes(class_list)
    class_list.split(',').each do |clazz|
      add_class(clazz.strip.capitalize)
    end
    @classes = ['N/A'] if @classes.compact.join.empty?
  end

  def add_year(year)
    @years << year
  end

  def add_years(year_list)
    year_list.split(',').each do |year|
      add_year(year.strip)
    end
    @years = ['N/A'] if @years.compact.join.empty?
  end

  def add_exchange(exchange)
    @exchanges_to << exchange
  end

  def add_exchanges(exchange_list)
    exchange_list.split(',').each do |exchange|
      add_exchange(exchange.strip)
    end
    @exchanges_to = ['N/A'] if @exchanges_to.compact.join.empty?
  end

  def add_source(source)
    @sources << source
  end

  def add_sources(source_list)
    source_list.split(',').each do |source|
      add_source(source.strip)
    end
    @source = ['N/A'] if @sources.compact.join.empty?
  end

  def token_hash
    {
        link: @link,
        image: @image_guid,
        helpers: @classes,
        rarity: @rarity,
        slot: @slot,
        years: @years,
        exchange_points: @exchange_points,
        exchanges_to: @exchanges_to,
        sources: @sources
    }
  end

end