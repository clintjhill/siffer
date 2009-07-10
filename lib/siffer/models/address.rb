module Siffer
  module Models
    class Street < Siffer::Xml::Body
      element :line_1, :type => :mandatory
      element :line_2
      element :line_3
      element :complex
      element :street_number
      element :street_prefix
      element :street_name
      element :street_type
      element :street_suffix
      element :apartment_type
      element :apartment_number_prefix
      element :apartment_number
      element :apartment_number_suffix
    end

    class GridLocation < Siffer::Xml::Body
      element :longitude
      element :latitude
    end

    class Address < Siffer::Xml::Body
      attribute :type
      element :street, :type => :mandatory
      element :city
      element :county
      element :state_province
      element :country
      element :postal_code
      element :grid_location
    end
    
    class AddressList < Siffer::Xml::Body
      element :address, :type => :mandatory
    end
  end
end