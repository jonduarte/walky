# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "walky/version"

Gem::Specification.new do |s|
  s.name          = "walky"
  s.version       = Walky::VERSION
  s.authors       = ["Jonathan Duarte"]
  s.email         = ["jonathan.duarte@rocketmail.com"]
  s.homepage      = "http://www.jonathanduarte.com.br"
  s.summary       = "Walky through hashes"
  s.description   = "Simple way to access hashes with nested keys"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec}/*`.split("\n")

  s.add_development_dependency "rspec"
end
