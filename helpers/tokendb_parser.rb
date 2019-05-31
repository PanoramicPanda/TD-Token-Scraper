require 'nokogiri'
require 'open-uri'
require_relative 'token.rb'
require_relative 'debugger.rb'

class TokenDBParser

  def initialize(max_pages = nil, debugger = false)
    @debugger = TDDebugger.new(debugger)
    @max_pages = max_pages.nil? ? get_max_pages : max_pages
    @all_pages = load_all_pages
    @tokens = []
  end

  def save_all_tokens(file)
    @debugger.start_time
    token_hash = {}
    @tokens.each do |token|
        token.download_token_image
        token_hash[token.name] = token.token_hash
    end
    File.write(file, JSON.pretty_generate(token_hash))
    @debugger.debug_message("Saved #{token_hash.size} tokens to #{file}.")
    @debugger.elapsed_time("Saving Tokens and Images")
  end

  def scrape_tokens
    @debugger.start_time
    @debugger.debug_message("Starting to scrape tokens...")
    @all_pages.each do |page|
      scrape_basic_tokens(page)
    end
    @debugger.elapsed_time("Scraping Token Data")
  end

  def scrape_basic_tokens(page)
    token_list = page.xpath("//div[contains(@class, 'dir-listing')]")
      raise "NO TOKENS ON PAGE!" if token_list.empty?
      token_list.each do |token_node|
        token = Token.new
        token_link = token_node.css('a.dir-title').first
        token.name = token_link.text
        token.link = token_link[:href]
    end
  end

  # <div class="dir-listing">
  # <div class="dir-logo"><a href="http://tokendb.com/token/1-amulet-of-armor/" title="+1 Amulet of Armor"><img width="100" height="100" src="http://tokendb.com/wp-content/uploads/2012/04/+1-Amulet-of-Armor-100x100.jpg" class="attachment-token thumb size-token thumb wp-post-image" alt="" srcset="http://tokendb.com/wp-content/uploads/2012/04/+1-Amulet-of-Armor-100x100.jpg 100w, http://tokendb.com/wp-content/uploads/2012/04/+1-Amulet-of-Armor-150x150.jpg 150w, http://tokendb.com/wp-content/uploads/2012/04/+1-Amulet-of-Armor-200x200.jpg 200w, http://tokendb.com/wp-content/uploads/2012/04/+1-Amulet-of-Armor.jpg 226w" sizes="(max-width: 100px) 100vw, 100px"></a></div>
  # <div class="dir-deets">
  # <h2><a href="http://tokendb.com/token/1-amulet-of-armor/" class="dir-title rarity-rare ">+1 Amulet of Armor</a></h2>
  # <div class="dir-tax">Usable by: <a href="http://tokendb.com/usable-by/all/" rel="tag">all</a>, <a href="http://tokendb.com/usable-by/barbarian/" rel="tag">Barbarian</a>, <a href="http://tokendb.com/usable-by/bard/" rel="tag">Bard</a>, <a href="http://tokendb.com/usable-by/cleric/" rel="tag">Cleric</a>, <a href="http://tokendb.com/usable-by/druid/" rel="tag">Druid</a>, <a href="http://tokendb.com/usable-by/dwarf-fighter/" rel="tag">Dwarf Fighter</a>, <a href="http://tokendb.com/usable-by/elf-wizard/" rel="tag">Elf Wizard</a>, <a href="http://tokendb.com/usable-by/fighter/" rel="tag">Fighter</a>, <a href="http://tokendb.com/usable-by/monk/" rel="tag">Monk</a>, <a href="http://tokendb.com/usable-by/paladin/" rel="tag">Paladin</a>, <a href="http://tokendb.com/usable-by/ranger/" rel="tag">Ranger</a>, <a href="http://tokendb.com/usable-by/rogue/" rel="tag">Rogue</a>, <a href="http://tokendb.com/usable-by/wizard/" rel="tag">Wizard</a>
  # </div>
  # <div class="dir-tax">Slot: <a href="http://tokendb.com/slot/neck/" rel="tag">Neck</a>
  # </div>
  # <div class="dir-tax">Rarity: <a href="http://tokendb.com/rarity/rare/" rel="tag">Rare</a>
  # </div>
  # <div class="dir-tax">Year: <a href="http://tokendb.com/pubyear/2003/" rel="tag">2003</a>, <a href="http://tokendb.com/pubyear/2004/" rel="tag">2004</a>, <a href="http://tokendb.com/pubyear/2005/" rel="tag">2005</a>, <a href="http://tokendb.com/pubyear/2006/" rel="tag">2006</a>
  # </div>
  # <p>Adds +1 to AC</p>
  # </div>
  # </div>

  def scrape_detailed_token(page)

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