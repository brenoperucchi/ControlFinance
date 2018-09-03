class Build < ApplicationRecord

  STATES = {pending: 'pending', active:'active'}

  store :information, accessors:[:address, :registry, :incorporation, :deadline]

  scope :active, ->{ where(state: 'active') }
  
  has_many :mailers,    class_name: 'Mailer', as: :mailable, dependent: :destroy
  has_many :units,      class_name: "Unit", :foreign_key => "build_id", dependent: :destroy
  has_many :proposals,  through: :units, :source => :proposals, dependent: :destroy
  has_many :admin_proposals,  through: :units, :source => :admin_proposals, dependent: :destroy
  has_many :assets,     class_name: "Asset", as: :assetable, dependent: :destroy

  belongs_to :store, optional: true

  validates_presence_of :name

  def image(scope = nil)
    img = assets.detect{|asset| asset.file.content_type.include?('image')}
    img.try(:file).try(:url, scope)
  end

  def images(scope = nil)
    imgs = assets.find_all {|asset| asset.file.content_type.include?('image')}
  end
end