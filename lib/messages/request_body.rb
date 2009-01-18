module Siffer
  
  module Messages
    
    # This class is used to parse the SIF Message information
    # out of the Request Body. It parses enough information to redirect
    # to other processes. It does not parse details of the Message such as
    # Protocol if a Register message, or Error if an Ack message. Each 
    # message type will inherit this class in order to provide a #parse
    # method that will allow access to those specific attributes.
    # It provides access to:
    # * source_id
    # * msg_id
    # * type
    class RequestBody
      
      def initialize(xml_string)
        @xml = xml_string
        @doc = Hpricot(@xml, :xml => true)
      end
      
      # Will return the name of the element found just inside the root
      # or just inside SIF_SystemControl if present. 
      def type
        begin
          msg_type = (@doc/:SIF_Message).first.children[0].name
          if msg_type == "SIF_SystemControl"
            msg_type = (@doc/:SIF_Message/:SIF_SystemControl).first.children[0].name
          end
          drop_sif msg_type
        rescue
          raise "Failed to parse #{@xml} for SIF Type"
        end
      end
      
      # The SIF_SourceId from the SIF_Header
      def source_id
        (@doc/"//SIF_Header/SIF_SourceId/").text
      end
      
      # The SIF_MsgId from the SIF_Header
      def msg_id
        (@doc/"//SIF_Header/SIF_MsgId/").text
      end
      
      # Parses the xml provided and returns a RequestBody.
      # Xml must respond to read or be a String.
      def self.parse(xml)
        unless xml.respond_to?("read") or xml.is_a?(String)
          raise "Unable to read Xml" 
        end
        xml = xml.read if xml.respond_to?("read")
        self.new(xml) # use self because we are going to inherit this class
      end
      
      private
        # Drops the SIF_ from the front of the string provided
        def drop_sif(string)
          string.gsub!("SIF_","")
        end
      
    end
    
  end
  
end