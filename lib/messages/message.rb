module Siffer
  module Messages
    
    # Base class for all Messages in the framework.
    class Message
    
      attr_reader :xmlns, :version, :header
    
      def initialize(source)
        raise ArgumentError, "Source not provided." if source.nil?
        @xmlns = Siffer.sif_xmlns
        @version = Siffer.sif_version
        @header = Header.new(source)
        @body = Builder::XmlMarkup.new
      end
      
      def content
        @body.SIF_Message(:version => Siffer.sif_version, 
                          :xmlns => Siffer.sif_xmlns) { |xml|
          yield xml if block_given?
        }
      end
      
      def put_header_into(xml)
        xml.SIF_Header { |head|
          head.SIF_MsgId(@header.msg_id)
          head.SIF_Timestamp(@header.timestamp)
          head.SIF_SourceId(@header.source_id)
        }
      end
      
      def to_str
        content
      end
      
      # Each Message requires a Header to identify the source.
      # You shouldn't need to initialize this by itself, it is
      # used by Message.
      class Header
      
        attr_reader :timestamp, :msg_id, :source_id
      
        def initialize(source)
          raise ArgumentError, "Source not provided." if source.nil?
          @timestamp = Time.now
          @msg_id = UUID.generate(:compact).upcase
          @source_id = source
        end
      
      end
  
    end
  end
end