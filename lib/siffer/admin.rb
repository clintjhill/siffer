require 'sequel'
require 'sinatra'
%w(server agent).each do |route|
  require "siffer/admin/routes/#{route}"  
end
require 'siffer/admin/database'
require 'siffer/admin/helpers'

module Siffer
  module Administration
    
    class Site < Sinatra::Application
      
      set :views, File.join(File.dirname(__FILE__),"admin","views")
      set :public, File.join(File.dirname(__FILE__),"admin","public")
      
      extend Siffer::Administration::Database      
      extend Siffer::Administration::Helpers
      extend Siffer::Administration::Routes::Server
      extend Siffer::Administration::Routes::Agent
      
      configure do
        check_for_schema  
      end
          
      get "/" do
        haml :index
      end
      
    end
    
  end
end