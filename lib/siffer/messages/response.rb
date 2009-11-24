module Siffer
  module Messages
    
    MORE_PACKETS = {
      :yes => "Yes",
      :no => "No"
    }
    
    # Provides element/attribute caption information for each column supplied in
    # ExtendedQuery. The order must correspend to the order in the ExtendedQuery
    #@see ExtendedQueryResults
    #@see Element
    class ColumnHeaders < SifBody
      element :element
    end
    
    class R < SifBody
      element :c
    end
    
    class Rows < SifBody
      element :r
    end
    
    # Element provides a wrapper for data returned in response to 
    # an ExtendedQuery
    #@see Response
    #@see ReportObject
    class ExtendedQueryResults < SifBody
      element :column_headers
      element :rows
    end
    
    # Used to respond to a SIF_Request message.
    # May span multiple SIF_Response messages.
    #@see Error
    #@see ExtendedQueryResults
    class Response < Message
      element :request_msg_id
      element :packet_number
      element :more_packets
      element :error
      element :object_data
      element :extended_query_results
    end
    
  end
end