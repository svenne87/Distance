module Api
  module V2
    class ContactsController < ApplicationController
      before_filter :restrict_access
      
      respond_to :json
    
      def index
        respond_with Contact.all
      end
      
      def show
        respond_with Contact.find(params[:id])
      end
      
      def create
        respond_with Contact.create(user_params)
      end
      
      def update                                #params[:contact]
        respond_with Contact.update(params[:id], user_params)
      end
      
      def destroy
        respond_with Contact.destroy(params[:id])
      end
      
      private 
        def restrict_access
          authenticate_or_request_with_http_token do |token, options|
            ApiKey.exists?(access_token: token)
        end
        
        def user_params
          params.require(:contact).permit(:name, :address, :units, :id, :longitude, :longitude)
        end
      end
      
    end
  end
end 
