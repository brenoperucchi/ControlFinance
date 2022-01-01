class Build < ApplicationRecord

  STATES = {pending: 'pending', active:'active'}

  store :information, accessors:[:address, :registry, :incorporation, :build_deadline, :proposal_deadline]
  scope :active, ->{ where(state: 'active') }
  
  has_many :mailers,    class_name: 'Mailer', as: :mailable, dependent: :destroy
  has_many :units,      class_name: "Unit", :foreign_key => "build_id", dependent: :destroy
  has_many :proposals,  through: :units, :source => :proposals, dependent: :destroy
  has_many :admin_proposals,  through: :units, :source => :admin_proposals, dependent: :destroy
  has_many :assets, ->{ where(serializes: "assets")}, class_name: "Asset", as: :assetable, dependent: :destroy
  has_many :images, ->{ where(serializes: "images")}, class_name: "Asset", as: :assetable, dependent: :destroy
  has_many :notifies,  class_name: "Notify  ", as: :notiable, dependent: :destroy

  belongs_to :store, optional: true
  acts_as_list scope: :store

  validates_presence_of :name

  def image(scope = nil)
    img = images.detect{|image| image.file.content_type.include?('image')}
    img.try(:file).try(:url, scope)
  end

  state_machine initial: :pending do
    event :active do 
      transition [:pending] => :active
    end
  end

  def units_sales?
    units.pending.count > 0
  end

end