require 'sprockets'
require 'sass'
require 'uglifier'

module AssetPipeline

  module Assets

    def self.registered(app)
      app.set :assets_prefix, "assets"
      app.set :sprockets, Sprockets::Environment.new(app.root).tap { |assets|
        assets.append_path "assets/stylesheets"
        assets.append_path "assets/javascripts"
        assets.js_compressor  = :uglify
        assets.css_compressor = :scss
      }

      app.get "/#{app.assets_prefix}/*" do
        env["PATH_INFO"].sub!(%r{^/#{settings.assets_prefix}}, "")
        settings.sprockets.call(env)
      end

    end
  end

end