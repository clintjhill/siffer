module Siffer
  module Messages
    class Acl
      
      # This class roles through all the objects in all the contexts in 
      # the zone to provide a list of allowed actions on each object per
      # registered agent
      
      def read
        xml = Builder::XmlMarkup.new
        xml.SIF_AgentAcl { |xml|
          # each one of these would collect all objects for each context
          xml.SIF_ProvideAccess
          xml.SIF_SubscribeAccess
          xml.SIF_PublishAddAccess
          xml.SIF_PublishChangeAccess
          xml.SIF_PublishDeleteAccess
          xml.SIF_RequestAccess
          xml.SIF_RespondAccess
        }
      end
      
    end
  end
end