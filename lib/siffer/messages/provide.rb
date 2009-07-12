module Siffer
  module Messages
    
    # Element used by SIF_Provide to represent the object being provided
    #@see Provide
    class Object < SifXml
      attribute :object_name
      element :extended_query_support
      element :contexts
    end
    
    # Message used to attempt registering as a provider of one or more data objects
    #@see Object
    class Provide < Message
      element :object, :type => :mandatory
    end
    
    # This message performs the opposite function of SIF_Provide.
    #@see Object
    class UnProvide < Message
      element :object, :type => :mandatory
    end
    
  end
end