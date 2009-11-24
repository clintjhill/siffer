module Siffer
  module Messages
             
    # Security Element for the Header Element 
    #@see Header
    class Security < SifBody
      element :secure_channel
    end
    
    # SecureChannel Element for the Security Element
    #@see Security
    class SecureChannel < SifBody
      element :encryption_level
      element :authentication_level
    end
    
    # List of Contexts for the Message
    class Contexts < SifBody
      element :context
    end
    
    # Header for all SIF_Message types
    #@see Message
    class Header < SifBody
      element :msg_id, :tag => "SIF_MsgId"
      element :timestamp, :tag => "SIF_Timestamp"
      element :security, :tag => "SIF_security"
      element :source_id, :tag => "SIF_SourceId", :required => true
      element :destination_id, :tag => "SIF_DestinationId"
      element :contexts, :tag => "SIF_Contexts"
      
      def initialize(values = {})
        values.update(:msg_id => UUID.generate(:compact).upcase) unless values.has_key?(:msg_id)
        values.update(:timestamp => Time.now.strftime("%Y-%m-%dT%H:%M:%SZ")) unless values.has_key?(:timestamp)
        super(values)
      end
      
    end
    
    # Base Message for all SIF_Message types
    class Message < SifBody
      element :header, Header
      
      def initialize(values={})
        values.update(:header => Header.new(:source_id => values[:header])) unless values[:header].nil?
        super(values)
      end
      
      alias_method :old_acdc, :acdc
      def acdc
        xml = Builder::XmlMarkup.new
        attrs = { :Version => Siffer.sif_version, :xmlns => Siffer.sif_xmlns }
        xml.tag!("SIF_Message", attrs){|body| body << old_acdc} 
        xml.target!
      end

    end

  end
end