module Siffer
  module Messages
    
    class Provision < Message
      element :provide_objects, :type => :mandatory
      element :subscribe_objects, :type => :mandatory
      element :publish_add_objects, :type => :mandatory
      element :publish_change_objects, :type => :mandatory
      element :publish_delete_objects, :type => :mandatory
      element :request_objects, :type => :mandatory
      element :respond_objects, :type => :mandatory
    end
    
  end
end