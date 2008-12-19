module Siffer
  module Messages
    class Ack < Message
      
      attr_reader :original_msg
      
      def initialize(source, original)
        super(source)
        @original_msg = original
      end
      
      def body
        content do |ack|
          ack.SIF_Ack() { |xml|
            put_header_into xml
            xml.SIF_OriginalSourceId(@original_msg.header.source_id)
            xml.SIF_OriginalMsgId(@original_msg.header.msg_id)
            yield xml if block_given?
          }
        end
      end
      
      def to_str
        body
      end
      
    end
  end
end