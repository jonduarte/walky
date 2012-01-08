module Walky
  module InstanceMethods
    attr_accessor :walky_path

    def same_path(*other)
      [].tap do | ary |
        ary << self
        other.each do |o|
          ary << Walker.parse(o, @walky_path)
        end
        ary.extend WalkMethods
      end
    end
  end
end
