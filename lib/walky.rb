require 'walky/parser'
require 'walky/walk_methods'
require 'walky/instance_methods'

module Walky
  class << self
    def move(hash, path)
      Walky::Parser.parse(hash, path)
    end
  end
  class Walker
    def initialize(hash)
      @hash = hash
    end
    
    def [](path)
      parse(path)
    end

    def walk(path)
      parse(path)
    end

    def parse(path)
      Walker.parse(@hash, path)
    end

    def self.parse(hash, path)
      Walky::Parser.parse(hash, path)
    end
  end
end
