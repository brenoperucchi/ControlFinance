# encoding: utf-8
class FileUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :fill50, :if => :is_picture? do
    process :resize_to_fill => [50, 50]
  end
  version :fit400, :if => :is_picture? do
    process :resize_to_fit => [400, 400]
  end

  protected

  def is_picture?(picture)
    picture.content_type.include?('image')
  end

end