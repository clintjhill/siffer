require File.join(File.dirname(__FILE__),"..", "lib","siffer")
require 'spec'

# Makes checking mandatory fields much easier.
# 
#  class Model < Siffer::Xml::Body
#    element :name, :type => :mandatory
#  end
#
#  describe Model do
#    it "should require Name" do
#      Model.should require(:name)
#    end
#  end
#
Spec::Matchers.define :require do |field|
  match do |obj|
    # get all declared elements
    declared = obj.instance_variable_get("@declared_values")
    # fill them all with value of 1
    filled = declared.inject({}){|acc,name| acc.merge(name => 1)}
    begin
      obj.new(filled.except(field)) # except the field were asserting is required
      return false # if no exception thrown the spec fails
    rescue Exception => e
      # if the exception is a MandatoryError and the message matches our field GOOD!!!
      e.is_a?(Siffer::Xml::MandatoryError) && e.message.match(/#{field.to_s.camelize}/)
    end
  end
end

Spec::Matchers.define :conditionally_require do |field, conditions|
  match do |obj|
    declared = obj.declared_values
    filled = declared.inject({}){|acc,name| acc.merge(name => 1)}
    updated = filled.update(conditions).except(field)
    begin
      obj.new(updated)
      return false
    rescue Exception => e
      e.is_a?(Siffer::Xml::ConditionalError) && e.message.match(/#{field.to_s.camelize}/)
    end
  end
end