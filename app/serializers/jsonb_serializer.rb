# frozen_string_literal: true

class JsonbSerializer
  def self.dump(hash)
    return hash.to_json if hash.is_a?(::Hash)
    return nil if hash.empty?

    hash
  end

  def self.load(hash)
    return nil if hash.nil?
    return nil if hash.empty?
    return JSON.parse(hash) if hash.is_a?(::String)

    hash
  end
end
