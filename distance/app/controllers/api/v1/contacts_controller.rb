module Api
  module V1
    class ContactsController < ApplicationController
      
      respond_to :json
    
      def index
        respond_with Contact.all
      end
      
    end
  end
end 
