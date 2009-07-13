class Hash
  
  # Recursively changes key names to underscored symbols
  def recursively_underscore
    keys.each do |key|
     if self[key].is_a?(Hash)
        self[key.underscore.to_sym] = delete(key).recursively_underscore
      else
        self[key.underscore.to_sym] = delete(key)
      end
    end
    self
  end

end