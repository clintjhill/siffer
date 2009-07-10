require File.join(File.dirname(__FILE__), "..", "spec_helper")

include Siffer::Xml

describe Body do
  
  class Duck < Body
    attribute :beek
    element :wings
  end
  
  it "should quack like string for equality tests" do
    @duck = Duck.new(:beek => "orange", :wings => ["one","two"])
    @duck.should eql("<Duck Beek=\"orange\"><Wings>onetwo</Wings></Duck>")
  end
  
  it "should expose proper Element name" do
    @duck = Duck.new
    @duck.send(:element_name).should eql("Duck")
  end
  
  it "should match against patterns" do
    @duck = Duck.new
    @duck.should match(/<Duck Beek=/)
  end
  
end