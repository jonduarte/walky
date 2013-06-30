require 'walky/version'
require 'walky/parser'
require 'walky/walk_methods'
require 'walky/instance_methods'

module Walky
  def self.move(hash, path)
    Walky::Parser.parse(hash, path)
  end

  def self.extract(hash, path)
    Walky::Parser.extract(hash, path)
  end

  def self.extract_with_sym(hash, path)
    Walky::Parser.extract_with_sym(hash, path)
  end

  class Walker

    def initialize(hash)
      @hash = hash
    end

    def parse(path)
      Walker.parse(@hash, path)
    end

    def self.parse(hash, path)
      Walky::Parser.parse(hash, path)
    end

    def extract(path)
      Walky::Parser.extract(@hash, path)
    end

    alias_method :[], :parse
    alias_method :walk, :parse
  end
end
