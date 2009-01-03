module Siffer
  module Messages
    
    class Register < Message
      
      attr_reader :name, :version, :vendor, :max_buffer, :mode
      
      def initialize(source, name, options = {})
        super(source, options)
        raise "Agent name required" unless name
        @name = name
        @version = options[:version] || Siffer.sif_version
        @max_buffer = options[:max_buffer] || 1024
        @mode = options[:mode] || 'Pull'
        @vendor = options[:vendor] || Siffer.vendor
      end
      
      def content
        body do |reg|
          reg.SIF_Register() { |xml|
            put_header_into xml
            reg.SIF_Name(@name)
            reg.SIF_Version(@version)
            reg.SIF_MaxBufferSize(@max_buffer)
            reg.SIF_Mode(@mode)
          }
        end
      end
      
    end
    
  end
end