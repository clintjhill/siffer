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
      e.is_a?(Siffer::Xml::ConditionalError) && e.message.match(/#{field.to_s.camelize}/)
    end
  end
end