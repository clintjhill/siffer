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
    class Condition < SifXml
      element :element, :type => :mandatory
      element :operator, :type => :mandatory
      element :value, :type => :mandatory
    end
    
    # List of Conditions
    #@see ConditionGroup
    class Conditions < SifXml
      attribute :type, CONDITION_GROUP_TYPES[:none]
      element :condition, :type => :mandatory
      
      def initialize(vals = {})
        if vals.has_key?(:condition) and vals[:condition].is_a?(Array)
          vals[:condition] = vals[:condition].inject([]) {|acc,hash| acc << Condition.new(hash)}
        end
        super(vals)
      end
    end
    
    # Represents a group conditions that the queried objects must meet.
    # If conditions are not specified all objects named are returned
    class ConditionGroup < SifXml
      attribute :type, CONDITION_GROUP_TYPES[:none]
      element :conditions, :type => :mandatory
      
      def initialize(vals = {})
        if vals.has_key?(:conditions)
          vals[:conditions] = Conditions.new(:condition => vals[:conditions])
        end
        super(vals)
      end
    end
    
    # The object that is being queried for
    class QueryObject < SifXml
      attribute :object_name
      element :element
    end
    
    # SIF's default query mechanism
    class Query < SifXml
      element :query_object, :type => :mandatory
      element :condition_group
      element :example
      must_have_one_of :condition_group, :example
      
      def initialize(vals = {})
        if vals.has_key?(:query_object) and vals[:query_object].is_a?(Hash)
          vals[:query_object] = QueryObject.new(vals[:query_object])
        end
        if vals.has_key?(:condition_group) and vals[:condition_group].is_a?(Hash)
          vals[:condition_group] = ConditionGroup.new(vals[:condition_group])
        end
        super(vals)
      end
    end
    
    # Element used in Select to identify the element/attribute
    #@see Select
    #@see Condition
    #@see OrderBy
    #@see QueryObject
    class Element < SifXml
      attribute :alias
      attribute :object_name
      attribute :ordering, ORDERING[:asc]
      attribute :xsi_type # need to work this out , it should be xsi:type
    end
    
    # Identifies elements to be returned as columns in a query
    #@see ExtendedQuery
    class Select < SifXml
      attribute :distinct, false
      attribute :row_count, 0 # This represents a number, 0 for all rows
      element :element, :type => :mandatory
    end
    
    # Specifies left join on which to constrain the join
    #@see JoinOn
    class LeftElement < SifXml
      attribute :object_name
    end
    
    # Specifies right join on which to constrain the join
    #@see JoinOn
    class RightElement < SifXml
      attribute :object_name
    end
    
    # Specifies conditions to limit/filter rows
    #@see ExtendedQuery
    class Where < SifXml
      element :condition_group, :type => :mandatory
    end
    
    # Optional list of elements/attributes by which to sort the resulting rows
    #@see ExtendedQuery
    class OrderBy < SifXml
      element :element, :type => :mandatory
    end
    
    # Specifies conditions for the join
    #@see From
    class JoinOn < SifXml
      element :left_element, :type => :mandatory
      element :right_element, :type => :mandatory
    end
    
    # Join specification for the query if more than one object is being queried
    #@see ExtendedQuery
    class From < SifXml
      attribute :object_name
      element :join
    end
    
    # A more advanced form of Query that allows for joins and retrieval of data
    # in row/column form.
    class ExtendedQuery < SifXml
      element :destination_provider
      element :select, :type => :mandatory
      element :from, :type => :mandatory
      element :where, :type => :mandatory
      element :order_by
    end
    
    # Message used to request information in SIF data objects from other SIF nodes.
    #@see Query
    #@see ExtendedQuery
    class Request < Message
      element :version, :type => :mandatory
      element :max_buffer_size, :type => :mandatory
      element :query
      element :extended_query
      must_have_one_of :query,:extended_query
      
      def initialize(vals = {})
        if vals.has_key?(:query) and vals[:query].is_a?(Hash)
          vals[:query] = Query.new(vals[:query])
        end
        super(vals)
      end
    end
    
  end
end