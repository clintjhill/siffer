require File.join(File.dirname(__FILE__),"..", "lib","siffer")
require 'spec'
require 'spec/interop/test'
require 'rack/test'

Spec::Matchers.define :require do |field|
  match do |obj|
    # get all declared elements
    declared = obj.declared_values
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
    # get all declared elements
    declared = obj.declared_values
    # fill them all with value of 1
    filled = declared.inject({}){|acc,name| acc.merge(name => 1)}
    # update them with the values of the conditions to check against 
    # and remove the field we're conditionalizing
    updated = filled.update(conditions).except(field)
    begin
      obj.new(updated)
      return false # if no exception thrown the spec fails
    rescue Exception => e
      # if the exception is a CondiionalError and the message matches our field GOOD!!!
      e.is_a?(Siffer::Xml::ConditionalError) && e.message.match(/#{field.to_s.camelize} is mandatory/) 
    end
  end
end

Spec::Matchers.define :must_have do |*fields|
  match do |obj|
    # get all declared elements
    declared = obj.declared_values
    # fill them all with a value of 1
    filled = declared.inject({}){|acc,name| acc.merge(name => 1)}
    fields.each{|field| filled.delete(field)}
    begin
      obj.new(filled)
      return false
    rescue Exception => e
      e.is_a?(Siffer::Xml::MustHaveError) && e.message.match(/must have one of #{fields.join(", ")}/)
    end
  end
end

Spec::Matchers.define :order_elements do |*fields|
  match do |obj|
    ordered = false
    fields.each_with_index do |field,index|
      ordered = obj.declared_values[index] == field
      break unless ordered
    end
    ordered
  end
end

Spec::Matchers.define :be_compliant do
  match do |msg|
    begin
      url = "http://compliance.sifinfo.org/validate/validate.jsp"
      result = RestClient.post(url, :xml => msg, :type => "SIF_Message")
      result.match(/class=\'valid\'/)
    rescue 
      warn "Not connected to internet - can't test compliance with SIFINFO.ORG!!"
    end
  end
end