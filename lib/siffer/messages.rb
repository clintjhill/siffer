module Siffer
  module Messages
    
    class SifBody < AcDc::Body
      def tag_name
        "SIF_#{super}"
      end
      
      class << self
        def acdc(xml)
          super(xml.gsub(/SIF_/,''))
        end
      end
    end

    class SifElement < AcDc::Element
      def initialize(values=nil, options={})
        @required = options[:required] || false
        super(value,options)
      end
      def required?
        @required
      end
      def tag_name
        "SIF_#{super}"
      end
    end
    
  end
end

require 'siffer/messages/message'
require 'siffer/messages/ack'
require 'siffer/messages/event'
require 'siffer/messages/provide'
require 'siffer/messages/provision'
require 'siffer/messages/register'
require 'siffer/messages/request'
require 'siffer/messages/response'
require 'siffer/messages/subscribe'
require 'siffer/messages/system_control'