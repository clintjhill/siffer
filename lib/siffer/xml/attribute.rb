module Siffer
  module Xml
    module Attribute
   
      # Class instance hash of attributes for the MessageElement
      # @return [Hash]
      def class_attributes
        self.class.instance_variable_get("@attributes") || {}
      end
      
      module ClassMethods

        # Creates an attribute for the instance. 
        def attribute(name, default = nil)
          @attributes ||= {}
          @attributes[name] = default
        end

      end
      
      def self.included(base)
        base.extend ClassMethods
      end
      
      private
        # Writes the values of each of the attributes found
        # in the values hash.
        def write_attributes(values)
          unless class_attributes.nil?
            attr_values = values.slice(*class_attributes.keys)
            attr_values.each{|k,v| class_attributes[k] = v}
          end
        end
        
        # Returns a hash without the attribute pairs from the values hash.
        def remove_attributes(values)
          values.except(*class_attributes.keys) rescue values
        end
        
        # Returns a new hash with all the keys (except xmlns)
        # camel cased.
        def camelized_attributes(attributes = class_attributes)
          attrs = {}
          attributes.each do |k,v|
            k = k.to_s.camelize.to_sym unless k == :xmlns
            attrs[k] = v
          end
          attrs
        end
    end
  end
end