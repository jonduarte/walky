module Walky
  module Parser
    def self.parse(hash, path)
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

    def self.extract_with_sym(hash, path)
      symbolize_keys(parse(hash, path))
    end

    def self.symbolize_keys(hash)
      {}.tap do |h|
        hash.each do |key, value|
          h[key.to_sym] = value
        end
      end
    end
  end
end
