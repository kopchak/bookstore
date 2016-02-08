class Customer < ActiveRecord::Base
  # ratyrate_rater
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :orders
  has_many :ratings
  belongs_to :billing_address, class_name: "Address"
  belongs_to :shipping_address, class_name: "Address"

  after_create :create_address

  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address

  validates :email, :encrypted_password, presence: true

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
  
  private
  def create_address
    self.build_billing_address
    self.build_shipping_address
    self.save
  end

end
