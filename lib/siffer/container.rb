module Siffer
  
  class Container
    
    attr_reader :environment, :component, :name, :host, :port, :log, :pid
    
    def initialize(options = {})
      
      if options[:config].nil? and options[:component] != "admin"
        raise "Component Configuration missing" 
      end
      
      raise "Environment missing" if options[:environment].nil?
      
      @environment = options[:environment]
      config = options[:config]
      type = config.keys.first
      if type == "admin"
        @component = Siffer::Administration::Site.new
        @host = "localhost"
        @port = options[:config]["admin"]["port"] || "2828"
      else
        @component = (type == "agent") ? 
                          Siffer::Agent.new(config["agent"]) : 
                          Siffer::Server.new(config["server"])
        @name = config[type]["name"]
        uri = URI.parse(config[type]["host"])
        @host = uri.host.nil? ? uri.to_s : uri.host
        @port = config[type]["port"]
      end
      @daemonize = options[:daemonize]
      @pid = options[:pid]
      @log = options[:log]
    end
    
    def daemonized?
      @daemonize
    end
    
    def run
      daemonize
      server = best_available_server
      options = { :Host => host, :Port => port }
      component.wake_up if component.respond_to?("wake_up")
      app = component_wrapped_in_environment
      server.run app, options
    end
    
    def stop
      pid_id = open("#{@pid}").read.to_i
      Process.kill(15,pid_id)
      File.delete(@pid) if File.exist?(@pid)
    end
    
    private
      def best_available_server
        begin 
          server = Rack::Handler::Mongrel
        rescue
          server = Rack::Handler::WEBrick
        end  
      end
      
      def component_wrapped_in_environment
        builder = Rack::Builder.new
        if component.instance_of? Siffer::Administration::Site
          builder.use(Rack::MethodOverride)
        end
        case environment
        when "development"
          builder.use(Siffer::RequestLogger)
          builder.use(Rack::CommonLogger)
          builder.run(component)
          builder
        when "deployment"
          builder.use(Rack::CommonLogger)
          builder.run(component)
          builder
        when "test": component
        when "none": component
        end
      end
      
      def daemonize
        if daemonized?
          if RUBY_PLATFORM !~ /mswin/
            require 'daemons/daemonize'
            Daemonize.daemonize(@log)
          else
            # How to tell about the problem of no Daemon on WINDOWS
          end
          write_pid_file
        end
      end
      
      def write_pid_file
        if RUBY_PLATFORM !~ /mswin/
          open(@pid,"w") do |f|
            f.write(Process.pid)
            File.chmod(0644, @pid)
          end      
        end
      end
           
  end
  
end