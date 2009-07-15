module Siffer
  module Messages
    
    # Raised when parsing XML that is not SIF compliant
    class NonSIFMessage < Exception; end
    
    # This class is used as the base for all SIF common types.
    class SifXml < Siffer::Xml::Body
      private
      # Overriden to prefix SIF to the element name
      def element_name(name = self.class)
        "SIF_#{name.to_s.split("::").last.camelize}"
      end
    end
        
    # Security Element for the Header Element 
    #@see Header
    class Security < SifXml
      element :secure_channel, :type => :mandatory
    end
    
    # SecureChannel Element for the Security Element
    #@see Security
    class SecureChannel < SifXml
      element :authentication_level, :type => :mandatory
      element :encryption_level, :type => :mandatory
    end
    
    # List of Contexts for the Message
    class Contexts < SifXml
      element :context, :type => :mandatory
    end
    
    # Header for all SIF_Message types
    #@see Message
    class Header < SifXml
      element :msg_id, :type => :mandatory
      element :timestamp, :type => :mandatory
      element :security
      element :source_id, :type => :mandatory
      element :destination_id
      element :contexts
      
      # Overloaded to provide defaults for Security, MsgId and Timestamp
      def initialize(values ={})
        values = values[:header] if values.has_key?(:header)
        super({:source_id => values[:source_id], 
              :msg_id => values[:msg_id] || UUID.generate(:compact).upcase,
              :timestamp => values[:timestamp] || Time.now,
              :security => create_security(values),
              :destionation_id => values[:destination_id],
              :contexts => values[:contexts]})
      end
      
      private
      
        def create_security(values)
          values = values[:security] unless values[:security].nil?
          values = values[:secure_channel] if values.is_a?(Hash) and values.has_key?(:secure_channel)
          if values.is_a?(Hash) and values.has_key?(:authentication_level) and values.has_key?(:encryption_level)
            secure_channel = SecureChannel.new(values)
          else
            secure_channel = SecureChannel.new(:authentication_level => 0, :encryption_level => 0)
          end          
          Security.new(:secure_channel => secure_channel)
        end
        
    end
    
    # Base Message for all SIF_Message types
    #@see Ack
    #@see Event
    #@see Provide
    #@see Provision
    #@see Register
    #@see Request
    #@see Response
    #@see Subscribe
    #@see SystemControl
    class Message < SifXml
      attribute :xmlns, Siffer.sif_xmlns
      attribute :version, Siffer.sif_version
      element :header, :type => :mandatory
      
      # Inspects values for :header and if exists injects new Header
      def initialize(values = {})
        if values.has_key?(:header) and values[:header].is_a?(Hash) 
          values[:header] = Header.new(values[:header])
        else
          values[:header] = Header.new(:source_id => values[:header])
        end
        super(values)
      end
      
      class << self
        def declared_values
          declared = super
          if subclass_of_message
            unless superclass.instance_variable_get("@declared_values").nil?
              declared << superclass.instance_variable_get("@declared_values")
            end
          end
          declared.flatten
        end
        
        def mandatory
          mandated = super
          if subclass_of_message
            unless superclass.instance_variable_get("@mandatory").nil?
              mandated << superclass.instance_variable_get("@mandatory") || []
            end 
          end
          mandated.flatten
        end
        
        def conditional
          conditioned = super
          if subclass_of_message
            unless superclass.instance_variable_get("@conditional").nil?
              conditioned.update superclass.instance_variable_get("@conditional") 
            end
          end
          conditioned
        end
        
        # Returns true if this instance is not a Message and its parent class is a Message.
        def subclass_of_message
          !instance_of?(Message) && superclass == Message
        end
        
        # Parses raw XML and initializes proper Message
        def parse(document)
          doc = Nokogiri::XML::Document.parse(document)  
          raise NonSIFMessage.new unless doc.xml? and doc.namespaces.values.include?(Siffer.sif_xmlns)
          # grab the version for validation later
          version = doc.children.first.attributes["Version"]
           
          # use the first child's children (the first child is the xml doctype)
          values = doc.children.first.children.inject({}) do |acc, subchild|
            prop_name = subchild.name.gsub(/SIF_/,"")
            acc.update(prop_name => parse_element(subchild))
          end
          
          klass = values.keys.first.constantize
          values.recursively_underscore
          props = values[values.keys.first]
          klass.new(props)
        end
      end
      
      private
      
      def subclass_of_message
        self.class.subclass_of_message
      end
      
      # Writes the elements and attributes to a SIF specific XML string
      def write_body(xml)
        if subclass_of_message
          super_attrs = camelized_attributes(self.class.superclass.class_attributes)
          args = (super_attrs.nil?) ? element_name(self.class.superclass) : [element_name(self.class.superclass), super_attrs]
          xml.tag!(*args) { |body| super(body) }
        else
          super(xml)
        end
      end
      
    end

  end
end