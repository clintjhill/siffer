require File.join(File.dirname(__FILE__),"..", "lib","siffer")
require 'spec'

module Spec
  module DSL
    module Main
      # we need to undef this because of Siffer::Messages::Contexts#context
      undef :context
    end
  end
end

def xml_file(filename)
  File.read(File.dirname(__FILE__) + "/xml/#{filename}")
end