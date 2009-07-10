module Siffer
  module Messages
    class Register < Message
      element :name, :type => :mandatory
      element :version, :type => :mandatory
      element :max_buffer_size, :type => :mandatory
      element :mode, :type => :mandatory
      element :bogus
      element :protocol, :type => :conditional, :conditions => [:bogus,{:mode => "Push"}]
    end
  end
end