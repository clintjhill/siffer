module Siffer
  module Messages
    
    # Message used by Agents to register themselves with the ZIS.
    class Register < Message
      
      attr_reader :name, :version, :vendor, :max_buffer, :mode
      
      def initialize(source, name, options = {})
        super(source, options)
        raise ArgumentError, "Agent name required" unless name
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
      
      # Parses the body passed as a Register message and returns a
      # RequestBody that provides access to Register properties.
      def self.parse(body)
        RegisterBody.parse(body)
      end
      
      class RegisterBody < RequestBody #:nodoc:
        
        def name
          (@doc/:SIF_Name).text
        end
      
        def version
          (@doc/:SIF_Version).text
        end
      
        def max_buffer
          (@doc/:SIF_MaxBufferSize).text.to_i
        end
      
        def mode
          (@doc/:SIF_Mode).text
        end
        
      end
      
    end
    
  end
end