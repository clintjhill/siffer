module Siffer
  module Administration
    module Helpers
      
      helpers do
        
        def error_messages_for(model)
          instance = instance_variable_get("@#{model}")
          unless instance.nil? or instance.valid?
            error_div = "<div id=\"error\">"
            error_div << "<h1>There was a problem saving:</h1>"
            error_div << "<ul>"
            instance.errors.each do |attr, error|
              error_div << "<li><b>#{attr.to_s.humanize}</b> #{error.join(' and ')}</li>"
            end
            error_div << "</ul>"
            error_div << "</div>"
          end
          
        end
        
      end
    end
  end
end