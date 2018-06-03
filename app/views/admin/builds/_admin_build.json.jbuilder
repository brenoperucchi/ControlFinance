json.extract! @brokers, :id, :created_at, :updated_at
json.url admin_build_url(admin_build, format: :json)