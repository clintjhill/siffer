require File.join(File.dirname(__FILE__), "..", "spec_helper")

include Siffer::Models
describe "DataElement" do

  class Mandatory
    include DataElement
    element :element, :mandatory
  end
  
  class Conditional
    include DataElement
    element :element
    element :required_conditionally, :conditional, :element
  end
  
  class Repeatable
    include DataElement
    element :element, :repeatable => true
  end
  
  it "should create getter/setter for each element" do
    @mandatory = Mandatory.new(:element => "one")
    @mandatory.should respond_to(:element)
    @mandatory.should respond_to(:element=)
  end
  
  it "should allow mandatory elements" do
    lambda{ Mandatory.new }.should raise_error(MandatoryError, /Element/)
  end
  
  it "should allow conditional elements" do
    lambda{ Conditional.new }.should raise_error(ConditionalError, /Required conditionally/)
  end
  
  it "should allow repeatable elements" do
    @repeater = Repeatable.new(:element => [Mandatory.new(:element => "one"),Mandatory.new(:element => "two")])
    @repeater.element.should have(2).items
  end
  
  it "should quack like a string for equality tests" do
    @mandatory = Mandatory.new(:element => "one")
    @mandatory.should eql("<Mandatory><Element>one</Element></Mandatory>")
  end
  
  it "should nest repeatable elements without encoding" do
    @repeater = Repeatable.new(:element => [Mandatory.new(:element => "one"),Mandatory.new(:element => "two")])
    @xml = "<Repeatable><Element><Mandatory><Element>one</Element></Mandatory></Element><Element><Mandatory><Element>two</Element></Mandatory></Element></Repeatable>"
    @repeater.should eql(@xml)
  end
end

