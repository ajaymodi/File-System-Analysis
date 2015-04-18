require 'bundler'

module Task2

  class Application
    def self.root(path = nil)
      @_root ||= File.expand_path(File.dirname(__FILE__))
      path ? File.join(@_root, path.to_s) : @_root
    end

    def self.env
      @_env ||= ENV['RACK_ENV'] || 'development'
    end

    # Initialize the application
    def self.initialize!
    end

  end
end

Bundler.require(:default, Task2::Application.env)

# Preload application classes
Dir['./app/**/*.rb'].each {|f| require f}
set :views, settings.root + '/app/views'
set :models, settings.root + '/app/models'
