module Siffer
  module Messages
    
    ConditionGroupTypes = {
      :and => "And",
      :or => "Or",
      :none => "None"
    }
    
    Operators = {
      :equals => "EQ",
      :less_than => "LT",
      :greater_than => "GT",
      :less_than_or_equals => "LE",
      :greater_than_or_equals => "GE",
      :not_equals => "NE"
    }
    
    class Condition < SifXml
      element :element
      element :operator
      element :value
    end
    
    class Conditions < SifXml
      attribute :type, ConditionGroupTypes[:none]
      element :condition, :type => :mandatory
    end
    
    # Represents conditions that the queried objects must meet.
    # If conditions are not specified all objects named are returned
    class ConditionGroup < SifXml
      attribute :type, ConditionGroupTypes[:none]
      element :conditions, :type => :mandatory
    end
    
    # The object that is being queried for
    class QueryObject < SifXml
      attribute :object_name
      element :element
    end
    
    # SIF's default query mechanism
    class Query < SifXml
      element :query_object, :type => :mandatory
      element :condition_group, :type => :conditional, :conditions => [:example]
      element :example, :type => :conditional, :conditions => [:condition_group]
    end
    
    # Message used to request information in SIF data objects from other SIF nodes.
    class Request < Message
      element :version, :type => :mandatory
      element :max_buffer_size, :type => :mandatory
      element :query, :type => :conditional, :conditions => [:extended_query]
      element :extended_query, :type => :conditional, :conditions => [:query]
    end
    
  end
end