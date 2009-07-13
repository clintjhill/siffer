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
    
    # Thrown when a conditional element is missing or a conditional value is met
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
      
    # A class that supports both the Element and Attribute models.
    # Used as a base class for classes wanting to take advantage of
    # a full Xml body.
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
      
      # Allows access to XML for checking on length
      # ??? Added to allow easier calls to Nokogiri
      def empty?
        to_xml.empty?
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
              values.each do |key, value|
                write_xml_element(body,key,value)           
              end 
            }
          end
        end

    end
    
  end
end