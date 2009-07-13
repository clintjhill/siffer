require File.join(File.dirname(__FILE__),"..","spec_helper")

describe Hash do
  
  it "should provide recursive underscoring" do
    test = {"SomeWeird" => {"Weirdness" => "Test"}}
    test.recursively_underscore
    test.should have_key(:some_weird)
    test[:some_weird].should have_key(:weirdness)
  end
  
end