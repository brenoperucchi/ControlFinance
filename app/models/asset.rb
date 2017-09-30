class Asset < ApplicationRecord
  belongs_to :assetable, polymorphic: true

  mount_uploader :file, FileUploader

end
