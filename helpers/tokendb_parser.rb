require 'nokogiri'
require 'open-uri'
require_relative 'token.rb'
require_relative 'debugger.rb'

class TokenDBParser

  attr_reader :tokens

  def initialize(options)
    debugger = options[:debugger] ? true : false
    max_pages = options[:max_pages]
    @debugger = TDDebugger.new(debugger)
    @max_pages = max_pages.nil? ? get_max_pages : max_pages
    @all_pages = load_all_pages
    @tokens = []
    @current_token
  end

  def save_all_tokens(file, image_directory)
    @debugger.start_time
    token_hash = {}
    @tokens.each do |token|
        token.download_token_image(image_directory)
        token_hash[token.name] = token.token_hash
    end
    File.write(file, JSON.pretty_generate(token_hash))
    @debugger.debug_message("Saved #{token_hash.size} tokens to #{file}.")
    @debugger.elapsed_time("Saving all Tokens and Images")
  end

  def scrape_tokens
    @debugger.start_time
    @debugger.debug_message("Starting to scrape tokens...")
    @all_pages.each_with_index do |page, index|
      @debugger.debug_message "Scraping page [#{index+1}]..."
      scrape_basic_tokens(page)
    end
    @debugger.elapsed_time("Scraping Token Data for [#{@tokens.size}] Tokens")
  end

  def scrape_basic_tokens(page)
    token_list = page.xpath("//div[contains(@class, 'dir-listing')]")
      raise "NO TOKENS ON PAGE!" if token_list.empty?
      token_list.each do |token_node|
        @current_token = Token.new

        # Token Link and Name
        token_link = token_node.css('a.dir-title').first
        @current_token.name = token_link.text
        @current_token.link = token_link[:href]

        # Token Image
        token_image = token_node.css('img').first[:src]
        token_image.gsub!('.jpg', '-150x150.jpg') unless token_image =~ /\d*x\d*.jpg$/
        @current_token.setup_token_image(token_image)

        # Token Information
        token_node.css('div.dir-tax').each do |detail|
          detail = detail.text.split(':')
          case detail[0]
          when /^Usable by/i
            @current_token.add_classes(detail[1])
          when /^Slot/i
            @current_token.slot = detail[1].strip
          when /^Rarity/i
            @current_token.rarity = detail[1].strip
          when /^Year/i
            @current_token.add_years(detail[1])
          end
        end
        scrape_detailed_token(@current_token.link)
        @tokens << @current_token
    end
  end

  def scrape_detailed_token(url)
    @debugger.debug_message "Scraping token page for [#{@current_token.name}]..."
    extra_details = open_page(url).css('div.dir-deets-single')
    extra_details.css('div.dir-tax').each do |detail|
      detail = detail.text.split(':')
      case detail[0]
      when /^Source/i
        @current_token.add_sources(detail[1])
      when /^Exchange Program/i
        s = detail[1].strip.chars[0] == '1' ? '' :'s'
        exchanges = detail[1].split(" unit#{s},")
        if exchanges[0] =~ /Reserve Bar/i
          @current_token.exchange_points = extract_gold_value(extra_details)
          @current_token.add_exchange('Reserve Bar')
        elsif exchanges[0] =~ /not exchangeable/i
          @current_token.exchange_points = '0'
          @current_token.add_exchange('Not Exchangeable')
        else
          @current_token.exchange_points = exchanges[0]
          @current_token.add_exchanges(exchanges[1])
        end
      end
    end
  end

  def extract_gold_value(node)
    node.at('p:contains(" GP")').first.text.split(' GP').first.split(' ').last
  end

  private

  def load_all_pages
    @debugger.start_time
    array = []
    (1..@max_pages).each do |page_number|
      url = page_number == 1 ? 'http://tokendb.com/searchresults/' : "http://tokendb.com/searchresults/page/#{page_number}/"
      array << open_page(url).css('div.site-inner')
    end
    @debugger.debug_message("Nokogiri loaded #{@max_pages} pages.")
    @debugger.elapsed_time("Loading HTML into Nokogiri")
    array
  end

  def open_page(link)
    Nokogiri::HTML(open(link))
  end

  def get_max_pages
    open_page('http://tokendb.com/searchresults/').xpath("//div[contains(@class, 'archive-pagination')]/ul/li[5]/a").first.text.split(' ')[1]
  end

end