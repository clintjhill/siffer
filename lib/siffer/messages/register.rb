module Siffer
  module Messages
    
    # Used by Protocol to describe the protocol used by the agent
    DEFINED_PROTOCOLS_TYPE = {
      :http => "HTTP",
      :https => "HTTPS"
    }
        
    # Used by Protocl to describe any protocol settings
    class Property < SifBody
      element :name
      element :value
    end
    
    # Contains protocol information regarding a ZIS or Agent.
    class Protocol < SifBody
      attribute :type, DEFINED_PROTOCOLS_TYPE[:https]
      attribute :secure, true
      element :url
      element :property
    end
    
    # Contains information about the vendor of the product that the agent represents
    class Application < SifBody
      element :vendor
      element :product
      element :version
    end
    
    # Register is a message for registering an agent with a ZIS. 
    # An agent must be registered before it sends out messages.
    class Register < Message
      element :name
      element :version
      element :max_buffer_size
      element :mode
      element :protocol
      element :node_vendor
      element :node_version
      element :application
      element :icon
    end
    
    # This message allows an agent to remove any association it has with the ZIS.
    #@see Register
    class Unregister < Message; end
    
  end
end