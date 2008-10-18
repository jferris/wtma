class User < ActiveRecord::Base
  include Clearance::App::Models::User

  validates_presence_of :openid_identity, :if => :email_blank?

  attr_accessible :first_name, :zip, :openid_identity, :email

  def self.find_or_create_by_openid(openid_identity, registration)
    User.find_by_openid_identity(openid_identity) ||
      User.new(:openid_identity => openid_identity,
                      :first_name => registration[:nickname],
                      :zip => registration[:postcode])
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
