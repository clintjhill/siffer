require File.join(File.dirname(__FILE__),"..","spec_helper")

include Siffer::Messages

describe ExtendedQueryResults do
  
  it "should require column headers" do
    ExtendedQueryResults.should require(:column_headers)
  end
  
  it "should require rows" do
    ExtendedQueryResults.should require(:rows)
  end
  
end

describe Response do
  
  it "should require request msg id" do
    Response.should require(:request_msg_id)
  end

  it "should require packet number" do
    Response.should require(:packet_number)
  end
  
  it "should require more packets" do
    Response.should require(:more_packets)
  end
  
  it "should conditionally require error on no object data and no extended query results" do
    Response.should conditionally_require(:error, :object_data => nil, :extended_query_results => nil)
  end
  
  it "should conditionally require object data on no error and no extended query results" do
    Response.should conditionally_require(:object_data, :error => nil, :extended_query_results => nil)
  end
  
  it "should conditionally require extended query results on no error and no object data" do
    Response.should conditionally_require(:extended_query_results, :error => nil, :object_data => nil)
  end
  
end