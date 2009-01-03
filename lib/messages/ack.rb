module Siffer
  module Messages
    
    class Ack < Message
      
      attr_reader :original_msg
      
      def initialize(source, original, options = {})
        super(source, options)
        @original_msg = original
        @error = options[:error] || nil
      end
      
      def content
        body do |ack|
          ack.SIF_Ack() { |xml|
            put_header_into xml
            xml.SIF_OriginalSourceId(@original_msg.source_id)
            xml.SIF_OriginalMsgId(@original_msg.msg_id)
            xml << @error.read unless @error.nil?
          }
        end
      end
      
    end
    
  end
end