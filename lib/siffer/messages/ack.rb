module Siffer
  module Messages
    
    class Ack < AcDc::Body
      
      tag_name "SIF_Ack"
      element :header, Header
      element :original_source_id, String, :tag => "SIF_OriginalSourceId"
      element :original_msg_id, String, :tag => "SIF_OriginalMsgId"
      element :status, Status
      element :error, Error
      
      def self.create(options = {}, &block)
        ack = Ack.new
        ack.header = Header.create(options)
        ack.original_msg_id = options[:original_msg_id]
        ack.original_source_id = options[:original_source_id]
        yield ack if block_given?
        raise "Original Msg Id is required" if ack.original_msg_id.nil?
        raise "Original Source Id is required" if ack.original_source_id.nil?
        ack
      end
      
      def self.status(options = {}, &block)
        ack = Ack.create(options)
        ack.status = Status.create(options)
        yield ack if block_given?
        ack
      end
      
    end
  end
end