class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_many :orders, dependent: :nullify
  has_many :ratings, dependent: :destroy
  belongs_to :billing_address, class_name: "Address", dependent: :destroy
  belongs_to :shipping_address, class_name: "Address", dependent: :destroy

  validates :email, :encrypted_password, presence: true

  after_create :create_address

  accepts_nested_attributes_for :billing_address
  accepts_nested_attributes_for :shipping_address


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |customer|
      customer.email = auth.info.email
      customer.password = Devise.friendly_token[0,20]
    end
  end

  def current_order
    orders.find_by(state: 'in_progress')
  end
  
  private
  def create_address
    self.build_billing_address
    self.build_shipping_address
    self.save
  end

end
