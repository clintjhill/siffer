module Siffer
  module Models
    class Street < AcDc::Body
      element :line_1
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

    class GridLocation < AcDc::Body
      element :longitude
      element :latitude
    end

    class Address < AcDc::Body
      attribute :type
      element :street
      element :city
      element :county
      element :state_province
      element :country
      element :postal_code
      element :grid_location
    end
    
    class AddressList < AcDc::Body
      element :address
    end
  end
end