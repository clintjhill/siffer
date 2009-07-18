module Siffer
  module Xml
    module Element
      
      attr_reader :values
      
      module ClassMethods
        
        # Class instance array of declared values (elements)
        # @return [Array]
        def declared_values
          declared = []
          declared << @declared_values
          declared.flatten
        end
        
        # Class instance array of mandatory element names
        # @return [Array]
        def mandatory
          mandated = []
          mandated << @mandatory unless @mandatory.nil?
          mandated.flatten
        end
        
        # Class instance hash of conditional element names and their conditions
        # @return [Hash]
        def conditional
          conditioned = {}
          conditioned.update @conditional unless @conditional.nil?
          conditioned
        end
        
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
        
        # Returns a hash with all elements and values set from the parsed XML
        #@return Hash
        def parse_element(xml)
          xml.children.inject({}) do |acc, child|
            child_name = child.name.gsub(/SIF_/,'')
            if child.children.size >= 1
              # if there is only 1 child and it's a text
              if child.children.size == 1 and child.child.text?
                # If the child is repeated, turn into an array of values
                # otherwise it will simply overwrite previous values
                if acc.has_key?(child_name)
                  arry_val = []
                  arry_val << acc[child_name]
                  arry_val << child.child.text
                  acc.update(child_name => arry_val.flatten)
                else
                  acc.update(child_name => child.child.text)
                end
              else
                if acc.has_key?(child_name)
                  arry_val = []
                  arry_val << acc[child_name].recursively_underscore
                  arry_val << parse_element(child).recursively_underscore
                  acc.update(child_name => arry_val.flatten)
                else
                  acc.update(child_name => parse_element(child))
                end
              end
            else
              # The child has no children - which means no text
              # If the child is repeated, turn into an array of values
              # otherwise it will simply overwrite previous values  
              child.attributes.recursively_underscore            
              if acc.has_key?(child_name)
                arry_val = []
                arry_val << acc[child_name]
                arry_val << child.attributes
                acc.update(child_name => arry_val.flatten)
              else  
                acc.update(child_name => child.attributes)
              end
            end
          end
        end

      end
      
      def self.included(base)
        base.extend ClassMethods
      end
      
      private
        
        # Writes the values to the instance.
        def write(values) 
          @values ||= {}
          unless self.class.declared_values.empty?
            self.class.declared_values.each do |name|
              if values.has_key?(name)
                @values[name] = values[name]
              end
            end
          end
        end

        # Validates the mandatory values are populated with a value.
        def check_mandatory(values)
          unless self.class.mandatory.empty?
            self.class.mandatory.each do |element|
              unless values.has_key?(element) && values[element]
                raise MandatoryError.new(element,self.class)
              end
            end
          end
        end

        # Validates the conditional values are populated with values.
        def check_conditional(values)
          unless self.class.conditional.empty?
            unless values.keys.any?{|v| self.class.conditional.has_key?(v) && values[v]}
              self.class.conditional.each do |element, conditions|
                
                # for each condition (if its a hash) lets check values     
                if conditions.is_a?(Hash)
                  conditions.keys.each do |specified|
                    # this captures the event that "specified" triggers and error when it matches 
                    # a particular value such as:
                    # Register should require Protocol when Mode == Push
                    if values[specified] == conditions[specified]
                      raise ConditionalError.new(element,conditions,self.class)
                    end
                  end
                end
                
                # # if all of the conditions exist in the values then it's good
                unless conditions.all?{|k,v| values.has_key?(k)}
                  raise ConditionalError.new(element,conditions,self.class)
                end
                                
              end
            end
          end
        end
        
        # Returns the name of this element and then camelized in the event
        # the name passed is not a class name.
        # Default name is self.class
        def element_name(name = self.class)
          name.to_s.split("::").last.camelize
        end
        
        # Writes the data to the XML either as a tag with a value or as a whole MessageElement.
        def write_xml_element(body,name,value)
          if value.is_a?(Element)
            body << value
          elsif value.is_a?(Array)
            value.each do |val|
              body.tag!(element_name(name)){ |tag| tag << val.to_s }
            end
          else
            body.tag!(element_name(name)){ |tag| tag << value.to_s }
          end
        end
        
    end
  end
end