module Siffer
  
  class Container
    
    attr_reader :environment, :component, :name, :host, :port, :log, :pid
    
    def initialize(options = {})
      raise "Component Configuration missing" if options[:config].nil?
      raise "Environment missing" if options[:environment].nil?
      @environment = options[:environment]
      config = options[:config]
      type = config.include?("agent") ? "agent" : "server"
      @component = (type == "agent") ? 
                  Siffer::Agent.new(config["agent"]) : 
                  Siffer::Server.new(config["server"])
      @name = config[type]["name"]
      @host = config[type]["host"]
      @port = config[type]["port"]
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
      options = {
        :Host => host,
        :Port => port
      }
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
        case environment
        when "development"
          builder = Rack::Builder.new
          builder.use(Siffer::RequestLogger)
          builder.use(Rack::CommonLogger)
          builder.run(@component)
          builder
        when "deployment"
          builder = Rack::Builder.new
          builder.use(Rack::CommonLogger)
          builder.run(@component)
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