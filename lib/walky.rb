require 'walky/version'
require 'walky/parser'
require 'walky/walk_methods'
require 'walky/instance_methods'

module Walky
  def self.move(hash, path)
    Parser.parse(hash, path)
  end

  class Walker
    def initialize(hash)
      @hash = hash
    end

    def move(path)
      Parser.parse(@hash, path)
    end

    def self.parse(hash, path)
      Parser.parse(hash, path)
    end

    alias_method :[], :move
  end
end
