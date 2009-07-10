require File.join(File.dirname(__FILE__),"..","spec_helper")

include Siffer::Xml

describe Attribute do
  
  it "should provide attribute access" do
    class AttrAccess
      include Attribute
      attribute :something
    end
    @attr = AttrAccess.new
    @attr.class_attributes.should include(:something)
  end
  
  it "should camelize attributes except xmlns" do
    class Camelized
       include Attribute
       attribute :object_name
       attribute :xmlns
     end
     @camelized = Camelized.new
     @camelized.send(:camelized_attributes).should include(:ObjectName)     
     @camelized.send(:camelized_attributes).should include(:xmlns)
  end
  
end