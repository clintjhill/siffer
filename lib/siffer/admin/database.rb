module Siffer
  module Administration
    
    module Database
      
      @@db = Sequel.sqlite
      
      def self.Tables(name)
        @@db[name]
      end
      
      def check_for_schema
        if @@db.tables.size == 0
         @@db.create_table :servers do 
           primary_key :id
           column :name, :string
           column :host, :string
           column :port, :integer
           column :minimum_buffer, :integer
           column :created_at, :datetime
           column :updated_at, :datetime
         end
        end
      end
      
      module Models
        class Server < Sequel::Model(Database.Tables([:servers]))
          # validates do
          #            presence_of :name, :host, :port, :minimum_buffer
          #            numericality_of :port, :minimum_buffer
          #           end
        end
      end
      
    end
  end
end