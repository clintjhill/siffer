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
  
  it "should conditionally require condition group if no example" do
    Query.should conditionally_require(:condition_group, :example => nil)
  end
  
  it "should conditionally require example if no condition group" do
    Query.should conditionally_require(:example, :condition_group => nil)
  end
  
end

describe Request do
  
  it "should require a version" do
    Request.should require(:version)
  end
  
  it "should require max buffer size" do
    Request.should require(:max_buffer_size)
  end
  
  it "should conditionally require query if no extended query" do
    Request.should conditionally_require(:query, :extended_query => nil)
  end
  
  it "should conditionally require extended query if no query" do
    Request.should conditionally_require(:extended_query, :query => nil)
  end
  
end
