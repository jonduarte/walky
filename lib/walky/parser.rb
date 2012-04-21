module Walky
  module Parser
    class << self
      def parse(hash, path)
        paths = path.split(" ")
        return_hash = hash
        paths.each do |pathy|
          if pathy =~ /^:/
            return_hash = return_hash[pathy.gsub(":", "").to_sym]
          else
            return_hash = return_hash[pathy]
          end
        end

        return_hash.extend InstanceMethods
        return_hash.walky_path = path

        return_hash
      end
    end
  end
end
