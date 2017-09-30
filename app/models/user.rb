class User < ApplicationRecord
  include SentientUser 
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  belongs_to :userable, polymorphic: true, optional: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable#, :validatable

  validates_format_of   :email, with: Devise::email_regexp, allow_blank: true  
  validates_presence_of :email#, :on => :create
  # validates :password, :email, presence: true, on: :create, unless: Proc.new {|x| !x.uid.blank?}
  # validates_confirmation_of :password
  # validates_length_of       :password, :within => 4..8, :allow_blank => false
  # validates :email, uniqueness: { scope: [:store_id], :case_sensitive => false, :allow_blank => true }

end