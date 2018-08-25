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
Rails.application.config.assets.precompile += %w( pages/pace-theme-flash.css pages/bootstrap.min.css pages/font-awesome.css pages/jquery.scrollbar.css pages/select2.min.css pages/switchery.min.css pages/pages-icons.css pages/pages.css)

Rails.application.config.assets.precompile += %w( pages/pace.min.js pages/jquery-1.11.1.min.js pages/modernizr.custom.js pages/jquery-ui.min.js pages/tether.min.js pages/bootstrap.min.js pages/jquery-easy.js pages/jquery.unveil.min.js pages/jquery.ioslist.min.js pages/jquery.actual.min.js pages/jquery.scrollbar.min.js pages/select2.full.min.js pages/classie.js pages/switchery.min.js pages/pages.min.js pages/scripts.js)

Rails.application.config.assets.precompile += %w( pages.css )
Rails.application.config.assets.precompile += %w( pages_print.css )
Rails.application.config.assets.precompile += %w( social.css )
Rails.application.config.assets.precompile += %w( pages/print.scss )
Rails.application.config.assets.precompile += %w( pages/social.scss )

Rails.application.config.assets.precompile += %w( pages/public/builds.scss )
Rails.application.config.assets.precompile += %w( pages/public/units.scss )
Rails.application.config.assets.precompile += %w( pages/public/dashboards.scss )
Rails.application.config.assets.precompile += %w( pages/public/brokers.scss )
Rails.application.config.assets.precompile += %w( pages/public/purchase_steps.scss )

Rails.application.config.assets.precompile += %w( pages/admin/builds.scss )
Rails.application.config.assets.precompile += %w( pages/admin/dashboards.scss )
Rails.application.config.assets.precompile += %w( pages/admin/brokers.scss )
Rails.application.config.assets.precompile += %w( pages/admin/proposals.scss )
Rails.application.config.assets.precompile += %w( pages/admin/mailers.scss )

Rails.application.config.assets.precompile += %w( pages.js )
Rails.application.config.assets.precompile += %w( social.js )
Rails.application.config.assets.precompile += %w( pages/print.js )
Rails.application.config.assets.precompile += %w( pages/social.js )

Rails.application.config.assets.precompile += %w( pages/public/builds.js )
Rails.application.config.assets.precompile += %w( pages/public/proposals.js )
Rails.application.config.assets.precompile += %w( pages/public/dashboards.js )
Rails.application.config.assets.precompile += %w( pages/public/units.js )
Rails.application.config.assets.precompile += %w( pages/public/brokers.js )
Rails.application.config.assets.precompile += %w( pages/public/purchase_steps.js )

Rails.application.config.assets.precompile += %w( pages/admin/builds.js )
Rails.application.config.assets.precompile += %w( pages/admin/dashboards.js )
Rails.application.config.assets.precompile += %w( pages/admin/brokers.js )
Rails.application.config.assets.precompile += %w( pages/admin/stores.js )
Rails.application.config.assets.precompile += %w( pages/admin/proposals.js )
Rails.application.config.assets.precompile += %w( pages/admin/mailers.js )

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