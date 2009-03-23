require 'rubygems'
require 'uuid'
require 'rack'
require 'builder'
require 'net/http'
require 'net/https'
require 'rexml/document'
require 'hpricot'

$: << File.expand_path(File.dirname(__FILE__))

module Siffer

    VENDOR = "h3o(software)" unless defined?(Siffer::VENDOR)
    VERSION = [0,0,5] unless defined?(Siffer::VERSION)
    SIF_VERSION = [2,2,0] unless defined?(Siffer::SIF_VERSION)
    SIF_XMLNS = "http://www.sifinfo.org/infrastructure/2.x" unless defined?(Siffer::SIF_XMLNS)
  
    # The vendor of this SIF implementation (self describing for Agents)
    def self.vendor() VENDOR end
      
    # The version of the h3o(software) SIF implementation
    def self.version() VERSION.join(".") end
  
    # The version of SIF being implemented - based on the specification
    def self.sif_version() SIF_VERSION.join(".") end
    
    # The SIF XML namespace to be used across this implementation
    def self.sif_xmlns() SIF_XMLNS end
  
    # The root directory that the SIF implementation is running from
    def self.root() @root ||= Dir.pwd end
    def self.root=(value) @root = value end
      
end

Siffer.autoload :Messages, "siffer/messages"
Siffer.autoload :Protocol, "siffer/protocol"
Siffer.autoload :Messaging, "siffer/messaging"
Siffer.autoload :Registration, "siffer/registration"

%w(admin server agent response request container request_logger).each do |component|
  require "siffer/#{component}"
end

class Hash
  
  # Return a new hash with all keys converted to symbols.
  # Will recursively check values to symbolize hash keys in nested hashes.
  def symbolize_keys
    inject({}) do |options, (key, value)|
      if value.is_a? Hash
        value = value.symbolize_keys
      end
      options[(key.to_sym rescue key) || key] = value
      options
    end
  end
  
end

class String
  
  def humanize
    gsub(/_id$/, "").gsub(/_/, " ").capitalize
  end
  
end