require 'bcrypt'
require 'securerandom'
class User < ApplicationRecord
  include BCrypt
  belongs_to :role
  after_initialize :set_default_role
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :email, uniqueness: true, presence: true
  validates :name, presence: true
  validates :password, presence: true, confirmation: true
  validates :password_confirmation, presence: true
  validates :role, presence: true
  
  scope :just_users, -> { where(role_id: Role.find_by_name('admin').id) }
  
  def login_api(email, pass)
    user = User.find_by_email(email)
    if (user) and (user.valid_password?pass)
      
      UserApi.delete_all "user_id = #{user.id}"
      
      user_api = UserApi.new
      user_api.user = user
      user_api.token = generate_token pass
      user_api.save
      return build_login(user_api)
    else
      raise "Invalid user or password"
    end
  end
  
  def photo_url
    photo.url
  end
  
  has_attached_file :photo,
    :styles => {
      :thumb => "100x100#",
      :small  => "150x150>",
      :medium => "200x200" 
    },
    :default_url => '/defaults/photos/user.png'
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/
  # add a delete_<asset_name> method: 
  attr_accessor :delete_photo
  before_validation { self.photo.clear if self.delete_photo == '1' }
  
  private
  def set_default_role
    self.role ||= Role.find_by_name('user')
  end
  
  def build_login(user_api)
    user = {};
    default_columns_json.each do |column|
      user[column.to_sym] = user_api.user.send(column)
    end
    result = {}
    result[:user] = user 
    result[:token] = user_api.token
    return result
  end
  
  def generate_token(pass)
    random_string = SecureRandom.hex
    salt = BCrypt::Engine.generate_salt
    result = BCrypt::Engine.hash_secret(pass,salt,random_string)
    return result
  end
  
  def default_columns_json  
    return ["id", "email", "name", "role_id", 
            "photo_url", "created_at", "updated_at"
    ]
  end
  
  RailsAdmin.config do |config|
    config.model 'User' do
      list do
        field :id
        field :name
        field :email
        field :role
      end
      edit do
        field :email
        field :name
        field :password
        field :password_confirmation
        field :role do
          visible do
            bindings[:view]._current_user.role.name == 'admin'
          end
        end
        field :photo
      end
    end
  end
   
end
