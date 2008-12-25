module Siffer
  
  class Container
    
    attr_reader :component, :name, :host, :port
    
    def initialize(options = {})
      raise "Component Configuration missing" if options[:config].nil?
      config = options[:config]
      @component = config.include?("agent") ? "agent" : "server"
      @name = config[@component]["name"]
      @host = config[@component]["host"]
      @port = config[@component]["port"]
    end
    
    def server
      begin 
        server = Rack::Handler::Mongrel
      rescue
        server = Rack::Handler::WEBrick
      end
    end
    
    #=Params
    # daemonize
    # environment
    # component
    # config = component,name,host,port
    # pid
    def self.run(options = {})
      
      begin 
        server = Rack::Handler::Mongrel
      rescue
        server = Rack::Handler::WEBrick
      end
      
      if options[:config]["server"]
        component = Siffer::Server.new(options[:config]["server"])
      else
        component = Siffer::Agent.new(options[:config]["agent"])
      end

      options[:Host] ||= component.host
      options[:Port] ||= component.port
    
      case options[:environment]
      when "development"
        app = Rack::Builder.new {
         use Rack::CommonLogger, STDERR
         use Rack::ShowExceptions
         use Rack::Lint
         run component
        }

      when "deployment"
       app = Rack::Builder.new {
         use Rack::CommonLogger, STDERR
         run component
       }

      when "none"
       app = component
      end

      if options[:daemonize]
        if RUBY_VERSION < "1.9"
          exit if fork
          Process.setsid
          exit if fork
          File.umask 0000
          STDIN.reopen "/dev/null"
          STDOUT.reopen "/dev/null", "a"
          STDERR.reopen "/dev/null", "a"
        else
          Process.daemon
        end
        
        File.open(options[:pid],'w') { |f| f.write("#{Process.pid}") }
        at_exit { File.delete(options[:pid]) if File.exist?(options[:pid]) }
      end
      
      server.run app, options
    end
    
  end
  
end