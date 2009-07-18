module Siffer
  module Messages
    
    # Used by Protocol to describe the protocol used by the agent
    DEFINED_PROTOCOLS_TYPE = {
      :http => "HTTP",
      :https => "HTTPS"
    }
        
    # Used by Protocl to describe any protocol settings
    class Property < SifXml
      element :name
      element :value
    end
    
    # Contains protocol information regarding a ZIS or Agent.
    class Protocol < SifXml
      attribute :type, DEFINED_PROTOCOLS_TYPE[:https]
      attribute :secure, true
      element :url
      element :property
    end
    
    # Contains information about the vendor of the product that the agent represents
    class Application < SifXml
      element :vendor, :type => :mandatory
      element :product, :type => :mandatory
      element :version, :type => :mandatory
    end
    
    # Register is a message for registering an agent with a ZIS. 
    # An agent must be registered before it sends out messages.
    class Register < Message
      element :name, :type => :mandatory
      element :version, :type => :mandatory
      element :max_buffer_size, :type => :mandatory
      element :mode, :type => :mandatory
      element :protocol, :type => :conditional, :conditions => {:mode => "Push"}
      element :node_vendor
      element :application
      element :icon
    end
    
    # This message allows an agent to remove any association it has with the ZIS.
    #@see Register
    class Unregister < Message; end
    
  end
end