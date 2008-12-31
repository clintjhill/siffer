require 'rexml/document'

module Siffer
  
  module Messages
    
    class RequestBody
      
      def initialize(xml_string)
        @xml = xml_string
        @doc = REXML::Document.new(@xml)
      end
      
      def type
        begin
          msg_type = @doc.root.elements[1].name
          unless msg_type != "SIF_SystemControl"
            xpath = "//SIF_SystemControl"
            msg_type = REXML::XPath.first(@doc,xpath).elements[1].name
          end
          drop_sif msg_type
        rescue
          raise "Failed to parse #{@xml} for SIF Type"
        end
      end
      
      def source
        begin
          xpath = "//SIF_Header/SIF_SourceId"
          REXML::XPath.first(@doc,xpath).text
        rescue
          raise "Failed to parse #{@xml} for SIF Source Id"
        end
      end
      
      def msg_id
        begin
          xpath = "//SIF_Header/SIF_MsgId"
          REXML::XPath.first(@doc,xpath).text
        rescue
          raise "Failed to parse #{@xml} for SIF Message Id"
        end
      end
      
      def self.parse(xml)
        unless xml.respond_to?("read") or xml.is_a?(String)
          raise "Unable to read Xml" 
        end
        xml = xml.read if xml.respond_to?("read")
        RequestBody.new(xml) 
      end
      
      private 
        def drop_sif(string)
          string.gsub!("SIF_","")
        end
      
    end
    
  end
  
end