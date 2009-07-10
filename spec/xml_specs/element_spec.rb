require File.join(File.dirname(__FILE__),"..","spec_helper")

include Siffer::Xml

describe Element do
  
  it "should provide mandatory elements" do
    class MandatoryElement
      include Element
      element :mandy, :type => :mandatory
    end
    @ele = MandatoryElement.new
    @ele.mandatory.should include(:mandy)
  end
  
  it "should provide conditional elements" do
    class ConditionalElement
      include Element
      element :option
      element :condition, :type => :conditional, :conditions => :option
    end
    @cond = ConditionalElement.new
    @cond.conditional.keys.should include(:condition)
    @cond.conditional.values.should include(:option)
  end
  
  it "should build getter/setter for each element" do
    class GetSet
      include Element
      element :element
    end
    @get_set = GetSet.new
    @get_set.should respond_to(:element)
    @get_set.should respond_to(:element=)
  end
  
end