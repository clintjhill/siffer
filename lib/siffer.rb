require 'rubygems'
require 'uuid'
require 'acdc'

module Siffer

    VENDOR = "h3o(software)" 
    VERSION = [0,1,2]
    SIF_VERSION = [2,3]
    SIF_XMLNS = "http://www.sifinfo.org/infrastructure/2.x"
  
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

    autoload :Messages, "siffer/messages"
        
end