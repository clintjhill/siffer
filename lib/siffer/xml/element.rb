module Siffer
  module Xml
    module Element
      
      attr_reader :values
      
      # Class instance array of declared values (elements)
      # @return [Array]
      def declared_values
        declared = []
        declared << self.class.instance_variable_get("@declared_values") unless self.class.instance_variable_get("@declared_values").nil?
        declared.flatten
      end
      
      # Class instance array of mandatory element names
      # @return [Array]
      def mandatory
        mandated = []
        mandated << self.class.instance_variable_get("@mandatory") unless self.class.instance_variable_get("@mandatory").nil?
        mandated.flatten
      end

      # Class instance hash of conditional element names and their conditions
      # @return [Hash]
      def conditional
        conditioned = {}
        conditioned.update self.class.instance_variable_get("@conditional") unless self.class.instance_variable_get("@conditional").nil?
        conditioned
      end
      
      module ClassMethods
        
        # Creates an element for the instance. Adds a getter/setter
        # and populates the mandatory and conditional
        # arrays accordingly based on the options provided.
        # @param [String] name the name of the element to create
        # @option options [Symbol] :type The type of element (:mandatory,:optional,:conditional)
        # @option options [Array] :conditions A list of elements in this class that this value is dependent.
        #   It will not throw an error if any of the conditional elements have value (currently there is no
        #   AND comparision, only an OR comparison).
        # @example 
        #  class Model
        #   include Element
        #   element :always_needed, :type => :mandatory
        #   element :sometimes_needed
        #   element :conditionally_needed, :type => :conditional, :conditions => [:sometimes_needed]
        #  end
        #  @model = Model.new(:always_needed => true, :conditionally_needed => true)
        #
        def element(name, options = {})
          @declared_values ||= []
          @declared_values << name
          class_eval "def #{name};@values[:#{name}];end"
          class_eval "def #{name}=(value);@values[:#{name}] = value;end"
          @mandatory ||= []
          @conditional ||= {}
          @mandatory << name if options[:type] == :mandatory
          @conditional[name] = options[:conditions] if options[:type] == :conditional
        end

      end
      
      def self.included(base)
        base.extend ClassMethods
      end
      
      private
        # Writes the values to the instance.
        def write(values) 
          @values ||= {}
          unless declared_values.empty?
            declared_values.each do |name|
              if values.has_key?(name)
                @values[name] = values[name]
              end
            end
          end
        end

        # Validates the mandatory values are populated with a value.
        def check_mandatory(values)
          unless mandatory.empty?
            mandatory.each do |element|
              unless values.has_key?(element) && values[element]
                raise MandatoryError.new(element,self.class)
              end
            end
          end
        end

        # Validates the conditional values are populated with values.
        def check_conditional(values)
          unless conditional.empty?
            unless values.keys.any?{|v| conditional.has_key?(v) && values[v]}
              conditional.each do |element, conditions|
                # for each condition (if its a hash) lets check values
                conditions.each do |condition|
                  if condition.is_a?(Hash) and values.has_key?(condition.keys.first)
                    if values[condition.keys.first] == condition.values.first
                      raise ConditionalError.new(element,condition,self.class)
                    end
                  end
                end
                
                # if any of the conditions exist in the values then it's good
                unless conditions.any?{|c| values.has_key?(c)}
                  raise ConditionalError.new(element,conditions,self.class)
                end
                
              end
            end
          end
        end
        
        def element_name(name = self.class)
          name.to_s.split("::").last.camelize
        end
        
        # Writes the data to the XML either as a tag with a value
        # or as a whole MessageElement.
        def write_xml_element(body,name,value)
          if value.is_a?(Element)
            body << value
          else
            body.tag!(element_name(name)){ |tag| tag << value.to_s }
          end
        end
        
    end
  end
end