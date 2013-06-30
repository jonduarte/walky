require 'walky/version'
require 'walky/parser'
require 'walky/walk_methods'
require 'walky/instance_methods'

module Walky
  def self.move(hash, path)
    Parser.parse(hash, path)
  end

  def self.change_root(hash, path)
    Parser.parse(hash, path)
  end

  def self.extract_with_sym(hash, path)
    Parser.extract_with_sym(hash, path)
  end

  class Walker
    def initialize(hash)
      @hash = hash
    end

    def parse(path)
      Parser.parse(@hash, path)
    end

    def self.parse(hash, path)
      Parser.parse(hash, path)
    end

    alias_method :[], :parse
    alias_method :change_root, :parse
    alias_method :walk, :parse
  end
end
