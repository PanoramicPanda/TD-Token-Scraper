require_relative 'helpers/token.rb'
require_relative 'helpers/tokendb_parser.rb'
require 'open-uri'

options = {debugger: true}
tokens = TokenDBParser.new(options)
tokens.scrape_tokens
tokens.save_all_tokens('../tokens.json', '../images')