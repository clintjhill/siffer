require File.join(File.dirname(__FILE__),"..","spec_helper")

include Siffer::Messages

describe Status do
  it "should require valid code" do
    lambda{
      Status.create do |s|
        s.code = 99
      end
    }
  end
end