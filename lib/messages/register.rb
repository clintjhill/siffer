module Siffer
  module Messages
    
    class Register < Message
      
      attr_reader :name, :version, :vendor, :max_buffer, :mode
      
      def initialize(source, name)
        super(source)
        raise "Agent name required" unless name
        @name = name
        @version = Siffer.sif_version
        @max_buffer = 1024
        @mode = 'Pull'
        @vendor = Siffer.vendor
      end
      
      def body
        content do |reg|
          reg.SIF_Register() { |xml|
            put_header_into xml
            reg.SIF_Name(@name)
            reg.SIF_Version(@version)
            reg.SIF_MaxBufferSize(@max_buffer)
            reg.SIF_Mode(@mode)
          }
        end
      end
      
      def to_str
        body
      end
      
    end
    
  end
end