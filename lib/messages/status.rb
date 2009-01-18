module Siffer
  module Messages
    
    class Status
      
      attr_reader :code, :description, :data
      
      def initialize(code,data)
        @code = code
        @description = CODES[code]
        @data = data
      end
      
      def read
        xml = Builder::XmlMarkup.new
        xml.SIF_Status { |status|
          status.SIF_Code(code)
          status.SIF_Description(description)
          if data.nil?
            status.SIF_Data
          else
            status.SIF_Data{ |data_node| data_node << data.read }
          end
        }
      end
      alias :to_str :read
      
      def self.method_missing(sym,*args)
        data = args.first
        status = nil
        CODES.each do |key, val|
          if val.downcase.to_sym == sym
            status =  Status.new(key,data)
          end
        end
        if status
          return status
        else
          super(sym,*args)
        end
      end
      
      CODES = {
        0 => "Success",
        1 => "Immediate",
        2 => "Intermediate", 
        3 => "Final",
        7 => "Duplicate",
        8 => "Sleeping", 
        9 => "No Messages"
      }
    end
    
  end
end