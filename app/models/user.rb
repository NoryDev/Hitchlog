class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username

  before_save :sanitize_username

  concerned_with :oauth
  
  has_friendly_id :username

  # chart_image method
  include Chart
  
  has_many :trips, :dependent => :destroy
  has_many :authentications, :dependent => :destroy

  validates :username, :presence => true, :uniqueness => true
  
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  def to_s
    username.capitalize
  end
  
  def to_param
    username
  end
  
  def hitchhikes
    trips.collect{|trip| trip.hitchhikes}.flatten
  end

  private
  def sanitize_username
    self.username.downcase
  end
end
