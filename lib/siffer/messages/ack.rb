module Siffer
  module Messages
    
    # Acknowledge Message
    # Used by Server and Agent to "acknowledge" receipt of a message. Allows
    # Erorr and Status messages to be injected into the body.
    class Ack < Message
      
      attr_reader :original_msg
      
      # 
      def initialize(source, original, options = {})
        raise ArgumentError, "Original message is required" unless original
        super(source, options)
        @original_msg = original
        @error = options[:error] || nil
        @status = options[:status] || nil
      end
      
      def content
        body do |ack|
          ack.SIF_Ack() { |xml|
            put_header_into xml
            if @original_msg.source_id.nil? or @original_msg.source_id == ""
              xml.SIF_OriginalSourceId
            else
              xml.SIF_OriginalSourceId(@original_msg.source_id)
            end
            if @original_msg.msg_id.nil? or @original_msg.msg_id == ""
              xml.SIF_OriginalMsgId
            else
              xml.SIF_OriginalMsgId(@original_msg.msg_id)
            end
            xml << @error.read unless @error.nil?
            xml << @status.read unless @status.nil?
          }
        end
      end
      
    end
    
  end
end