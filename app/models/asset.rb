class Asset < ApplicationRecord

  # store :serializes, accessors:[:name, :status, :kind]
  
  belongs_to :assetable, polymorphic: true

  mount_uploader :file, FileUploader

end