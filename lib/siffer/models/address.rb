module Siffer
  module Models
    class Street 
      include DataElement
      element :line_1, :mandatory
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

    class GridLocation
      include DataElement
      element :longitude
      element :latitude
    end

    class Address
      include DataElement
      attribute :type
      element :street, :mandatory
      element :city
      element :county
      element :state_province
      element :country
      element :postal_code
      element :grid_location
    end
    
    class AddressList
      include DataElement
      element :address, :mandatory
    end
  end
end