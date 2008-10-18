class User < ActiveRecord::Base
  include Clearance::App::Models::User

  acts_as_mappable({:lat_column_name => :latitude,
                    :lng_column_name => :longitude,
                    :auto_geocode => {:field => :location}})
                    
  validates_presence_of :openid_identity, :if => :email_blank?
  validates_presence_of :location, :latitude, :longitude

  attr_accessible :first_name, :zip, :openid_identity, :email, :location

  has_many :purchases

  def self.find_or_create_by_openid(openid_identity, registration, user)
    User.find_by_openid_identity(openid_identity) ||
      User.new(:openid_identity => openid_identity,
               :first_name => registration['nickname'],
               :zip => registration['postcode'],
               :location => user[:location])
  end

  def nearby_stores
    Store.find(:all, :origin => [latitude, longitude],
                     :within => Store.nearby_miles)
  end

  private

  def email_blank?
    email.blank?
  end

  def email_required?
    openid_identity.blank?
  end

  def password_required?
    email_required? && (crypted_password.blank? || !password.blank?)
  end
end
