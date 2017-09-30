class RackWithQuietAssets
  def initialize(app)
    @app = app

    quiet_assets_paths = [ %r[\A/{0,2}#{Rails.application.config.assets.prefix}] ]
    @assets_regex = /\A(#{quiet_assets_paths.join('|')})/
  end

  def call(env)
    if env['PATH_INFO'] =~ @assets_regex
      Rails.logger.silence do
        @app.call(env)
      end
    else
      @app.call(env)
    end
  end
end