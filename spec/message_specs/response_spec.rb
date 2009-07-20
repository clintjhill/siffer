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
  
  it "should have one of :error, :object_data, :extended_query_result" do
    Response.should must_have(:error,:object_data,:extended_query_results)
  end
    
end