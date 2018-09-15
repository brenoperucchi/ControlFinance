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

  belongs_to :store, optional: true
  acts_as_list scope: :store

  validates_presence_of :name
  # validates_numericality_of :row_order, on: :create, message: "is not a number", if: proc { |obj| obj.condition? }}

  def position=(value)
    self.insert_at(value.to_i)
  end

  def image(scope = nil)
    img = images.detect{|image| image.file.content_type.include?('image')}
    img.try(:file).try(:url, scope)
  end

  state_machine initial: :pending do
    event :active do 
      transition [:pending] => :active
    end
    # after_transition :pending => :aproved, :do => :create_ledger
  end

  def units_sales?
    units.pending.count > 0
  end

  # def images(scope = nil)
  #   imgs = assets.find_all {|asset| asset.file.content_type.include?('image')}
  # end
end