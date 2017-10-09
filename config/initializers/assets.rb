# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( elite.js )
Rails.application.config.assets.precompile += %w( elite.css )
Rails.application.config.assets.precompile += %w( elite/default.scss )
Rails.application.config.assets.precompile += %w( elite/mailers.scss )
Rails.application.config.assets.precompile += %w( elite/mailers.js )

Rails.application.config.assets.precompile += %w( elite/public/builds.scss )
Rails.application.config.assets.precompile += %w( elite/public/builds.js )
Rails.application.config.assets.precompile += %w( elite/public/proposals.js )
Rails.application.config.assets.precompile += %w( elite/public/proposals.scss )
Rails.application.config.assets.precompile += %w( elite/public/purchase_steps.js )
Rails.application.config.assets.precompile += %w( elite/public/purchase_steps.scss )

Rails.application.config.assets.precompile += %w( elite/admin/builds.js )
Rails.application.config.assets.precompile += %w( elite/admin/builds.scss )
Rails.application.config.assets.precompile += %w( elite/admin/proposals.js )
Rails.application.config.assets.precompile += %w( elite/admin/proposals.scss )