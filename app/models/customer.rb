class Customer < ActiveRecord::Base
  # ratyrate_rater
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :orders
  has_many :ratings
  has_many :credit_cards
  belongs_to :billing_address, class_name: "Address"
  belongs_to :shipping_address, class_name: "Address"

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |customer|
      customer.email = auth.info.email
      customer.password = Devise.friendly_token[0,20]
    end
  end

  def self.new_with_session(params, session)
    super.tap do |customer|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        customer.email = data["email"] if customer.email.blank?
      end
    end
  end
end
