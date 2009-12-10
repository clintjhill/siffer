module Siffer
  module Messages
    
    class SecureChannel < AcDc::Body
      tag_name "SIF_SecureChannel"
      element :authentication_level, Integer, :tag => "SIF_AuthenticationLevel"
      element :encryption_level, Integer, :tag => "SIF_EncryptionLevel"
    end
    
    class Security < AcDc::Body
      tag_name "SIF_Security"
      element :secure_channel, SecureChannel
      
      def self.create(options = {}, &block)
        security = Security.new
        security.secure_channel = SecureChannel.new
        security.secure_channel.encryption_level = options[:encryption] || 0
        security.secure_channel.authentication_level = options[:authentication] || 0
        yield security if block_given?
        security
      end
    end
    
    class Contexts < AcDc::Body
      tag_name "SIF_Contexts"
      element :context, String, :tag => "SIF_Context", :single => false
    end
    
    class Header < AcDc::Body
      
      tag_name "SIF_Header"
      
      element :msg_id, String, :tag => "SIF_MsgId"
      element :timestamp, DateTime, :tag => "SIF_Timestamp"
      element :security, Security
      element :source_id, String, :tag => "SIF_SourceId"
      element :destination_id, String, :tag => "SIF_DestinationId"
      element :contexts, Contexts
      
      def self.create(options = {}, &block)
        head = Header.new
        head.source_id = options[:source]
        head.msg_id = options[:msg_id] || UUID.generate(:compact).upcase
        head.timestamp = options[:timestamp] || Time.now.strftime("%Y-%m-%dT%H:%M:%SZ")
        head.security = Security.create(options)
        yield head if block_given?
        raise "Source is required for Header" if head.source_id.nil?
        raise "Message Id is required for Header" if head.msg_id.nil?
        raise "Timestamp is require for Header" if head.timestamp.nil?
        head
      end
      
    end
  end
end