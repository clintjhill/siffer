module Siffer
  module Messages
    
    # Base class for all Messages in the framework. Embeds the XMLNS as
    # well as the version of SIF implemented.
    class Message
    
      attr_reader :xmlns, :version, :header
      
      # source parameter is required (string describing the original sender)
      def initialize(source, options = {})
        raise ArgumentError, "Source not provided." if source.nil?
        @xmlns = options[:xmlns] || Siffer.sif_xmlns
        @version = options[:version] || Siffer.sif_version
        @header = Header.new(source)
        @body = Builder::XmlMarkup.new
      end
      
      # Builds the xml for this message. Accepts a block if nested 
      # elements are required.
      def content
        @xml ||= @body.SIF_Message(:version => @version, :xmlns => @xmlns) { |xml|
          yield xml if block_given?
        }
      end
      
      # Alias method to the Header SourceId
      def source_id() header.source_id; end
      # Alias method to the Header MsgId
      def msg_id() header.msg_id; end
      
      # used to remove the stack too deep issue when overridden
      # there has to be a better way .... TODO: Fix the alias crap
      alias :body :content 
      
      def put_header_into(xml)
        xml.SIF_Header { |head|
          head.SIF_MsgId(@header.msg_id)
          head.SIF_Timestamp(@header.timestamp)
          head.SIF_SourceId(@header.source_id)
        }
      end
      
      # Returns the content of the message
      def read
        # this construct prevents the xml from being built
        # over and over again for every read made to this
        # message.
        @xml ||= content
      end
      alias :to_str :read
      
      def length
        content.length
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