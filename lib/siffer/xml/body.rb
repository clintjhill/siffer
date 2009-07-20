module Siffer
  module Xml
    
    # Thrown when a mandatory element is missing from a set of values
    #@see Body
    class MandatoryError < Exception
      def initialize(element,klass)
        @element = element
        @klass = klass
      end
      def message
        "#{@element.to_s.camelize} is mandatory for #{@klass}."
      end
    end
    
    # Thrown when a conditional value is met
    #@see Body
    class ConditionalError < Exception
      def initialize(element,conditions,klass)
        @element = element
        @klass = klass
        @conditions = conditions
      end
      def message
        if @conditions.is_a?(Hash)
          "#{@element.to_s.camelize} is mandatory for #{@klass} if #{@conditions.keys.first.to_s.camelize} equals #{@conditions.values.first}"
        else
          @conditions = @conditions.delete_if{|c| c.is_a?(Hash)}
          "#{@element.to_s.camelize} is mandatory for #{@klass} if #{@conditions.map{|c| c.to_s.camelize}.join(" or ")} is missing"
        end
      end
    end
    
    # Thrown when one of a set of conditions is missing
    class MustHaveError < Exception
      def initialize(conditions,klass)
        @conditions = conditions
        @klass = klass
      end
      def message
        "#{@klass} must have one of #{@conditions.join(", ")}."
      end
    end  
    
    # A class that supports both the Element and Attribute models.
    # Used as a base class for classes wanting to take advantage of a full Xml body.
    class Body
      include Element
      include Attribute
      
      # Set attributes, write values and check mandatory and conditional elements
      # @raise [MandatoryError] If a mandatory element is missing from initialization
      # @raise [ConditionalError] If a conditional element is missing from initialization
      def initialize(values = {})
        write_attributes(values)
        values = remove_attributes(values)
        write(values)
        check_mandatory(values)
        check_conditional(values)
        check_must_have(values)
      end
     
      # Overridden to assure comparison is done by string.
      # Uses the #to_xml call to compare with the #to_s call of the other object.
      # @see #to_xml
      def eql?(other)
        to_xml == other.to_s
      end
      
      # Overridden to assure match occurs on string.
      # Uses the #to_xml call to match against pattern.
      # @see #to_xml
      def match(pattern)
        to_xml.match(pattern)
      end
      
      # Writes the elements and attributes to XML string
      def to_xml
        xml = Builder::XmlMarkup.new
        write_body(xml)
        xml.target!
      end
      
      # Delegates to XML for checking
      # ??? Added to allow easier calls to Nokogiri
      def empty?
        to_xml.empty?
      end
      
      # Delegates to XML for checking
      # ??? Added to allow RESTClient to work
      def size
        to_xml.size
      end
      
      # Delegates to XML for checking
      # ??? Added to allow RESTClient to work
      def length
        to_xml.length
      end

      alias :to_str :to_xml
      alias :to_s :to_xml 
      alias :inspect :to_xml
      
      private 
        # Writes the body of the XML document. Includes attributes for the class instance.
        def write_body(xml)
          args = (self.class.class_attributes.nil?) ? element_name : [element_name, camelized_attributes]
          if values.empty? 
            xml.tag!(*args) # just write xml closed tag
          else
            xml.tag!(*args) { |body|
              self.class.declared_values.each do |key|
                write_xml_element(body,key,values[key])
              end 
            }
          end
        end

    end
    
  end
end