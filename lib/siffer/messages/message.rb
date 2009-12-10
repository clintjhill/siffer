module Siffer
  module Messages
    class Message < AcDc::Body
      
      namespace Siffer.sif_xmlns
      tag_name "SIF_Message"
      attribute :Version, String
      element :ack, Ack
      
      def initialize
        self.Version = Siffer.sif_version
      end
      
    end
  end
end