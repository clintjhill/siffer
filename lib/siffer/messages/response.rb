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
    class ColumnHeaders < SifXml
      element :element
    end
    
    class R < SifXml
      element :c, :type => :mandatory
    end
    
    class Rows < SifXml
      element :r
    end
    
    # Element provides a wrapper for data returned in response to 
    # an ExtendedQuery
    #@see Response
    #@see ReportObject
    class ExtendedQueryResults < SifXml
      element :column_headers, :type => :mandatory
      element :rows, :type => :mandatory
    end
    
    # Used to respond to a SIF_Request message.
    # May span multiple SIF_Response messages.
    #@see Error
    #@see ExtendedQueryResults
    class Response < Message
      element :request_msg_id, :type => :mandatory
      element :packet_number, :type => :mandatory
      element :more_packets, :type => :mandatory
      element :error, :type => :conditional, :conditions => [:object_data, :extended_query_results]
      element :object_data, :type => :conditional, :conditions => [:error, :extended_query_results]
      element :extended_query_results, :type => :conditional, :conditions => [:error, :object_data]
    end
    
  end
end