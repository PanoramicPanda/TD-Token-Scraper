require_relative 'helpers/token.rb'
require_relative 'helpers/tokendb_parser.rb'
require 'open-uri'

tokens = TokenDBParser.new
tokens.scrape_tokens
tokens.save_all_tokens('../tokens.json', '../images')