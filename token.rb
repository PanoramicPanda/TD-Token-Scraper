require 'securerandom'
require 'rest-client'

class Token

  attr_accessor :name, :link, :rarity, :slot, :exchange_points
  attr_reader :token_image_guid, :classes, :years, :exchanges_to, :sources

  def initialize
    @name = ''
    @link = ''
    @token_image_full = ''
    @token_image_guid = ''
    @classes = []
    @rarity = ''
    @slot = ''
    @years = []
    @exchange_points = ''
    @exchanges_to = []
    @sources = []
  end

  def setup_token_image(image_url)
    @token_image_full = image_url
    extension = '.jpg'
    @token_image_guid = "#{SecureRandom.uuid.gsub('-','').upcase}#{extension}"
  end

  def download_token_image
    File.write("images/#{@token_image_guid}", RestClient.get(@token_image_full).body, mode: 'wb')
  end

  def add_class(td_class)
    @classes << td_class
  end

  def add_year(year)
    @years << year
  end

  def add_exchange(exchange)
    @exchanges_to << exchange
  end

  def add_source(source)
    @sources << source
  end

  def token_hash
    {
        link: @link,
        image: @token_image_guid,
        classes: @classes,
        rarity: @rarity,
        slot: @slot,
        years: @years,
        exchange_points: @exchange_points,
        exchanges_to: @exchanges_to,
        sources: @sources
    }
  end

end