module Siffer
  # The Registration module manages Register message types and processes
  # registration requests.
  module Registration

    include Siffer::Messages

    class AgentNotRegistered < Exception #:nodoc:
    end
    
    # The request (message) is processed for registration requests.
    def process_registration
      begin
        check_for_registration
        register
      rescue AgentNotRegistered
        error_response(4,9)
      end
    end
    
    # Parses the request body with RequestBody to determine if the 
    # the request is a registration message. If it is or if the 
    # source is already registered it passes through, otherwise raises
    # AgentNotRegistered exception.
    def check_for_registration 
      unless @request.register? or registered?(@request.message.source_id)
        raise AgentNotRegistered
      end
    end
    
    # Process the message for registration by validating:
    # * source_id
    # * permissions to register with ZIS
    # * version compatibility
    # * buffer size compatibility
    # If all validations pass the registration is stored by the ZIS and
    # the agent is added to the list of agents available to the zone.
    def register
      if @request.register?
        @registration = Register.parse(@request.body)
        validate_source_id
        validate_permission
        validate_version
        validate_max_buffer_size
        # ignore the fact we haven't stored away any registration information !!!!!!
        # ignore the fact we haven't even built a data model for objects and permissions for the acl !!!!!
        ack = Ack.new(name, @request.original, :status => Status.success(Acl.new))
        @response = Response.new(ack)
      end
    end
    
    # We may not do anything here - will we pre-permit sources to register?
    # We could possibly call the Central Admin to qualify the source there?
    def validate_source_id
    end
    
    
    # We need to check for permissions previously assigned for this
    # agent (possibly from Central Admin).
    def validate_permission
    end
    
    # Currently only validating that the registration version matches
    # identically to the SIF version implemented by Siffer.
    # TODO: This will need refinement to provide broader version support.
    def validate_version
      if @registration.version != Siffer.sif_version
        error_response(5,4,"Unsupported version: #{@registration.version}")
      end
    end
    
    # Validates the registration buffer size is greater than the 
    # minimum buffer set by the ZIS.
    def validate_max_buffer_size
      if @registration.max_buffer < min_buffer
        error_response(5,6)
      end
    end
    
    # Returns true if the agent is included in the list of Agents
    # previously registered.
    def registered?(agent)
      agents.has_key? agent
    end
    
  end
end