require_relative 'token.rb'
require 'json'

# Will re-write into unit tests soon

test = Token.new

test.name = 'Gauntlets of Ogre Power'
test.link = 'http:\/\/tokendb.com\/token\/gauntlets-of-ogre-power\/'
classes = ['all', 'Barbarian', 'Bard', 'Cleric', 'Druid', 'Dwarf Fighter', 'Elf Wizard', 'Fighter', 'Monk', 'Paladin', 'Ranger', 'Rogue', 'Wizard']
classes.each{ |td_class| test.add_class(td_class) }
test.rarity = 'Rare'
test.slot = 'Hands'
years = ['2003', '2004', '2005', '2006', '2007', '2008', '2012', '2016']
years.each{ |year| test.add_year(year) }
test.exchange_points = '6'
test.add_exchange('Mystic Silk')
test.add_source('Standard Pack')

test_array = Array.new(5, test)

mega_hash = {}
test_array.each_with_index do |token, index|
  token.name = token.name + index.to_s
  token.setup_token_image('http://tokendb.com/wp-content/uploads/2012/06/Gauntlets-of-Ogre-Power-100x100.jpg')
  token.download_token_image
  mega_hash[token.name] = token.token_hash
end

File.write("tokens.json", JSON.pretty_generate(mega_hash))