module Siffer
  module Models
    
    class MandatoryError < Exception
      def initialize(element,klass)
        @element = element
        @klass = klass
      end
      def message
        "#{@element.to_s.humanize} is mandatory for #{@klass}."
      end
    end
    class ConditionalError < Exception
      def initialize(element,conditions,klass)
        @element = element
        @klass = klass
        @conditions = conditions
      end
      def message
        "#{@element.to_s.humanize} is mandatory for #{@klass} if #{@conditions.map{|c| c.to_s.humanize}.join(" or ")} is missing"
      end
    end
    
    module DataElement
      
      def initialize(values = {})
        write_attributes(values)
        values = remove_attributes(values)
        write(values)
        check_mandatory(values)
        check_conditional(values)
      end

      def write_attributes(values)
        @attributes ||= {}
        unless class_attributes.nil?
          class_attributes.each{|k,v| @attributes[k] = v}
          attr_values = values.slice(*class_attributes.keys)
          attr_values.each{|k,v| @attributes[k] = v}
        end
      end

      def remove_attributes(values)
        values.except(*class_attributes.keys) rescue values
      end

      def write(values) 
        @values ||= {}
        values.each do |k,v| 
          if repeatable.include? k
            @values[k] ||= []
            if v.is_a? Array
              @values[k] += v
            else
              @values[k] << v
            end
          else
            @values[k] = v
          end
        end
      end

      def check_mandatory(values)
        mandatory.each do |element|
          unless values.keys.include?(element)
            raise MandatoryError.new(element,self.class)
          end
        end
      end

      def check_conditional(values)
        unless values.keys.any?{|v| conditional.keys.include?(v)}
          conditional.each do |element, conditions|
            unless conditions.any?{|c| values.keys.include?(c)}
              raise ConditionalError.new(element,conditions,self.class)
            end
          end
        end
      end
      
      def eql?(other)
        to_xml == other.to_s
      end

      def class_attributes
        self.class.instance_variable_get("@attributes")
      end

      def mandatory
        self.class.instance_variable_get("@mandatory")
      end

      def conditional
        self.class.instance_variable_get("@conditional")
      end
      
      def repeatable
        self.class.instance_variable_get("@repeatable")
      end

      def to_xml
        xml = Builder::XmlMarkup.new
        args = (@attributes.nil?) ? self.class.to_s : [self.class.to_s, @attributes]
        xml.tag!(*args) { |body|
          @values.each do |key, value|
            if repeatable.include?(key)
              value.each do |item|
                body.tag!(key.to_s.classify){ |tag| tag << item }
              end
            else
              body.tag!(key.to_s.classify){ |tag| tag << value }
            end            
          end 
        }
        xml.target!
      end

      alias :to_str :to_xml
      alias :to_s :to_xml

      module ClassMethods

        def element(name, type = :optional, repeat_options = {:repeatable => false}, *conditions)
          class_eval "def #{name};@values[:#{name}];end"
          class_eval "def #{name}=(value);@values[:#{name}] = value;end"
          @mandatory ||= []
          @repeatable ||= []
          @conditional ||= {}
          @mandatory << name if type == :mandatory
          @repeatable << name if :repeatable
          @conditional[name] = conditions if type == :conditional
        end

        def attribute(name, default = nil)
          @attributes ||= {}
          @attributes[name] = default
        end

      end

      def self.included(base)
        base.extend ClassMethods
      end
    end
  end
end