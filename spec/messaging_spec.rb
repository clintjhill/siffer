require File.join(File.dirname(__FILE__),"spec_helper")

# The messaging is best tested doing a full request/response
# cycle using both Server and Agent components

[Siffer::Server, Siffer::Agent].each do |component|
  
  # Stage the component a little bit:
  #    Agents require Servers
  #    Both require central-admin 
  component = component.new("admin" => 'none', "servers" => '')
  msg = Siffer::Messages::Message.new("source")
  msg.content do |xml|
    xml.SIF_BogusType
  end
  
  describe component, "Messaging - response" do
    it "should always return Ack for proper SIF_Messages" do
      for_every_path(:on => component, :input => msg) do |res|
        res.body.should match(/SIF_Ack/)
      end
    end
  end
  
  describe component, "Messaging - content-type" do
    it "should always respond with application/xml" do
      for_every_path(:on => component, :input => msg) do |res|
        res.content_type.should == Siffer::Messaging::MIME_TYPES["appxml"]
      end
    end
    
    it "should only receive application/xml" do
      for_every_path(:on => component,"CONTENT_TYPE" => "x") do |res|
        res.should be_client_error
        res.status.should == 406
      end
    end
  end
  
  describe component, "Messaging - validation" do
    
    it "should return Xml Error code for bad message (xml)" do
      %w[<Junk>>>> <Junk> </Junk> Junk !@ex].each do |msg|
        for_every_path(:on => component, :input => msg) do |res|
          res.body.should match(/SIF_Error/)
          res.body.should match(/SIF_Category>1<\/SIF_Category/)
          res.body.should match(/SIF_Code>2<\/SIF_Code>/)
          res.body.should match(/Message is not well-formed/)
          # spec says Oringals should be included and empty
          res.body.should match(/SIF_OriginalSourceId\s*\/>/)
          res.body.should match(/SIF_OriginalMsgId\s*\/>/)
        end
      end
    end
    
    it "should validaate message is SIF_Message" do
      msg = "<someotherkind><of>XML</of></someotherkind>"
      for_every_path(:on => component, :input => msg) do |res|
        res.body.should match(/SIF_Category>12/)
        res.body.should match(/SIF_Code>2/)
      end
    end
    
    it "should validate message xmlns" do
      msg = Siffer::Messages::Register.new(
                                      "bad-xmlns",
                                      component.name,
                                      :xmlns => 'http://bogus.xmlns')
      for_every_path(:on => component, :input => msg) do |res|
        res.body.should match(/SIF_Category>1<\/SIF_Category/)
        res.body.should match(/SIF_Code>4<\/SIF_Code/)
        res.body.should match(/SIF_ExtendedDesc>XMLNS not compatible with SIF/)
      end
    end
    
    it "should validate SIF version" do
      msg = Siffer::Messages::Register.new(
                                      "bad-version", 
                                      component.name, 
                                      :version => '99.99')
      for_every_path(:on => component, :input => msg) do |res|
        res.body.should match(/SIF_Category>12<\/SIF_Category/)
        res.body.should match(/SIF_Code>3<\/SIF_Code>/)
      end
    end
  end

end