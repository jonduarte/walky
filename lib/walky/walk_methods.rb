module Walky
  module WalkMethods
    def all(&block)
      if block_given?
        yield(self)
      end
    end
  end
end
