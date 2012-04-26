require 'httparty'

module KAG
  include HTTParty

  # Internal: KAG API URI (JAFAs all the way!)
  API = 'http://api.kag2d.com'

  base_uri API
end
