class ContactsController < ApplicationController
  
  around_filter :catch_not_found
  
  def new
    @contact = Contact.new
  end
  
  def create
    @contact = Contact.new(params[:contact].permit(:name, :address, :units))
  
    if @contact.save
      redirect_to @contact
    else 
      render 'index'
    end
  end
  
  def index    
    if params[:search].present?
      @contacts = Contact.near(params[:search], 15)
      @maps = @contacts.to_gmaps4rails
    elsif params[:contactDep].present? && params[:contactDest].present?
      if params[:contactDep] == params[:contactDest]
        redirect_to root_url + "contacts", :error => "Record not found." 
      else
        @contactDest = Contact.find(params[:contactDest])
        @contactDep = Contact.find(params[:contactDep])
        #the distance between the two contacts
        @distanceBetween = (@contactDep.distance_to(@contactDest) * 1.609344).round(2)
        @info = " km mellan kontakterna."
        
        if @contactDep.units > @contactDest.units
          @unitsSpent = @contactDep.units - @contactDest.units;
        else
          @unitsSpent = @contactDest.units - @contactDep.units;
        end
        
        @unitsInfo = ' enheter mellan kontakterna';
      
        @contacts = Contact.find(params[:contactDep], params[:contactDest])
        @maps = @contacts.to_gmaps4rails
        

        polyline = []
        polyline[0] = {:lat => @contactDest.latitude,:lng => @contactDest.longitude}
        polyline[1] = {:lat => @contactDep.latitude,:lng => @contactDep.longitude}
        @polylines_json = polyline.to_json

         respond_to do |format|
           format.html
           format.json { render json: @polylines_json }
         end
        
        #json här
        
      end
    else
      @contacts = Contact.all
      @maps = @contacts.to_gmaps4rails
      
      #respond_to do |format|
      #  format.html
      #  format.json { render json: @contacts }
      #end
      
    end
    
    @json = Contact.all.to_gmaps4rails
    #visitor on page (ip)
    @visitor = request.location.city 
    
  end
  
  def show
    @contact = Contact.find(params[:id])
    @map = @contact.to_gmaps4rails
  end
  
  def update
    @contact = Contact.find(params[:id])
    
    if @contact.update(params[:contact].permit(:name, :address, :units))
      redirect_to @contact
    else
      reder 'new'
    end
  end
  
  def edit
    @contact = Contact.find(params[:id])
  end
  
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to contacts_path    
  end
  
  private 
    def contact_params
      params.require(:contact).permit(:name, :address, :units)  
    end
    
    def catch_not_found
      yield
    rescue ActiveRecord::RecordNotFound
      redirect_to root_url+"contacts", :flash => { :error => "Record not found." }
    end
    
end
