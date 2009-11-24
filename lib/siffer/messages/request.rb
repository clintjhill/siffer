module Siffer
  module Messages
    
    CONDITION_GROUP_TYPES = {
      :and => "And",
      :or => "Or",
      :none => "None"
    }
    
    OPERATORS = {
      :equals => "EQ",
      :less_than => "LT",
      :greater_than => "GT",
      :less_than_or_equals => "LE",
      :greater_than_or_equals => "GE",
      :not_equals => "NE"
    }
    
    ORDERING = {
      :asc => "Ascending",
      :des => "Descending"
    }
    
    # Represents a condition used in a Query
    #@see Conditions
    class Condition < SifBody
      element :element
      element :operator
      element :value
    end
    
    # List of Conditions
    #@see ConditionGroup
    class Conditions < SifBody
      attribute :type, CONDITION_GROUP_TYPES[:none]
      element :condition
    end
    
    # Represents a group conditions that the queried objects must meet.
    # If conditions are not specified all objects named are returned
    class ConditionGroup < SifBody
      attribute :type, CONDITION_GROUP_TYPES[:none]
      element :conditions
    end
    
    # The object that is being queried for
    class QueryObject < SifBody
      attribute :object_name
      element :element
    end
    
    # SIF's default query mechanism
    class Query < SifBody
      element :query_object
      element :condition_group
      element :example
    end
    
    # Element used in Select to identify the element/attribute
    #@see Select
    #@see Condition
    #@see OrderBy
    #@see QueryObject
    class Element < SifBody
      attribute :alias
      attribute :object_name
      attribute :ordering, ORDERING[:asc]
      attribute :xsi_type # need to work this out , it should be xsi:type
    end
    
    # Identifies elements to be returned as columns in a query
    #@see ExtendedQuery
    class Select < SifBody
      attribute :distinct, false
      attribute :row_count, 0 # This represents a number, 0 for all rows
      element :element
    end
    
    # Specifies left join on which to constrain the join
    #@see JoinOn
    class LeftElement < SifBody
      attribute :object_name
    end
    
    # Specifies right join on which to constrain the join
    #@see JoinOn
    class RightElement < SifBody
      attribute :object_name
    end
    
    # Specifies conditions to limit/filter rows
    #@see ExtendedQuery
    class Where < SifBody
      element :condition_group
    end
    
    # Optional list of elements/attributes by which to sort the resulting rows
    #@see ExtendedQuery
    class OrderBy < SifBody
      element :element
    end
    
    # Specifies conditions for the join
    #@see From
    class JoinOn < SifBody
      element :left_element
      element :right_element
    end
    
    # Join specification for the query if more than one object is being queried
    #@see ExtendedQuery
    class From < SifBody
      attribute :object_name
      element :join
    end
    
    # A more advanced form of Query that allows for joins and retrieval of data
    # in row/column form.
    class ExtendedQuery < SifBody
      element :destination_provider
      element :select
      element :from
      element :where
      element :order_by
    end
    
    # Message used to request information in SIF data objects from other SIF nodes.
    #@see Query
    #@see ExtendedQuery
    class Request < Message
      element :version
      element :max_buffer_size
      element :query
      element :extended_query
    end
    
  end
end