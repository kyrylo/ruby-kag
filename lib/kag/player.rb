module KAG
  class Player
    include HTTParty

    attr_accessor :username


    base_uri 'http://api.kag2d.com'

    def initialize(username)
      @username = username
    end

    def info(force = false)
      if force
        @info = get_info
      else
        @info ||= get_info
      end
    end

    def method_missing(m, *args, &block)
      @info.fetch(m.to_s) { super }
    end

    protected

    def get_info
      self.class.get "/player/#@username/info"
    end

  end
end
