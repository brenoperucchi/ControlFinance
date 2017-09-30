class AssetPresenter
  # include CarrierWave::MimeTypes

  def initialize(object)
    if object.is_a?(Asset)
      @asset = object
    elsif object.is_a?(Asset::ActiveRecord_Associations_CollectionProxy)
      @assets = object
    end
  end

  def to_json
    if @asset
        return json(@asset)
    elsif @assets
      return @assets.collect{|asset| json(asset)}
    end
  end

  private
    def json(asset)
      {"asset": {
          "id": asset.id,
          "name" => asset.file_identifier,
          "type": asset.file.content_type,
          "size": asset.file.size,
          "url" => asset.file.url,
          "imageURL": asset.file.try(:url),
          "accepted": true,

        }
      }
    end
end