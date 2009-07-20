require File.join(File.dirname(__FILE__),"..","spec_helper")

include Siffer::Messages

describe Conditions do

  it "should require condition" do
    Conditions.should require(:condition)
  end
  
end

describe ConditionGroup do

  it "should require conditions" do
    ConditionGroup.should require(:conditions)
  end
  
end

describe Query do

  it "should require object type" do
    Query.should require(:query_object)
  end
  
  it "should must have :condition_group, :example" do
    Query.should must_have(:condition_group, :example)
  end
  
end

describe JoinOn do
  
  it "should require LeftElement" do
    JoinOn.should require(:left_element)
  end
  
  it "should require RightElement" do
    JoinOn.should require(:right_element)
  end
  
end

describe Where do
  
  it "should require condition group" do
    Where.should require(:condition_group)
  end
  
end

describe Select do
  
  it "should require element" do
    Select.should require(:element)
  end
  
end

describe ExtendedQuery do
  
  it "should require select" do
    ExtendedQuery.should require(:select)
  end
  
  it "should require from" do
    ExtendedQuery.should require(:from)
  end
  
  it "should require where" do
    ExtendedQuery.should require(:where)
  end
  
end

describe Request do
  
  it "should require a version" do
    Request.should require(:version)
  end
  
  it "should require max buffer size" do
    Request.should require(:max_buffer_size)
  end
  
  it "should must have :query, :extended_query" do
    Request.should must_have(:query, :extended_query)
  end
  
end
