class Contact < ActiveRecord::Base
  validates :name, :address, presence: true,
  length: { minimum: 2 }
  
  geocoded_by :address
  acts_as_gmappable :latitude => "latitude", :longitude => "longitude", :process_geocoding => :geocode?,
                    :address => "address", :normalized_address => "address", :msg => "Sorry, inte ens google kunde hitta den adressen."
  
  def geocode?
    (!address.blank? && (latitude.blank? || longitude.blank?)) || address_changed?
  end
  
  def gmaps4rails_infowindow
    "<h4>#{name}</h4><p>#{address}</p>"
  end
  
end
