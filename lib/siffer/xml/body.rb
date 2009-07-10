module Siffer
  module Xml
     class MandatoryError < Exception
        def initialize(element,klass)
          @element = element
          @klass = klass
        end
        def message
          "#{@element.to_s.camelize} is mandatory for #{@klass}."
        end
      end

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
      end
     
      # Overridden to assure comparison is done by string.
      # Uses the MessageElement#to_xml call to compare with the #to_s call
      # of the other object.
      # @see MessageElement#to_xml
      def eql?(other)
        to_xml == other.to_s
      end
      
      # Overridden to assure match occurs on string.
      # Uses the MessageElement#to_xml call to match against pattern.
      # @see MessageElement#to_xml
      def match(pattern)
        to_xml.match(pattern)
      end
      
      # Writes the elements and attributes to XML string
      def to_xml
        xml = Builder::XmlMarkup.new
        write_body(xml)
        xml.target!
      end

      alias :to_str :to_xml
      alias :to_s :to_xml 
      alias :inspect :to_xml
      
      private 
        # Writes the body of the XML document. Includes attributes for the class instance.
        def write_body(xml)
          args = (class_attributes.nil?) ? element_name : [element_name, camelized_attributes]
          xml.tag!(*args) { |body|
            values.each do |key, value|
              write_xml_element(body,key,value)           
            end 
          }
        end

    end
    
  end
end