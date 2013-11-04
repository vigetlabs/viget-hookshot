require 'sinatra'
require 'sinatra/namespace'
require 'active_support/inflector/inflections'
require 'active_support/core_ext/string'

Dir[File.join(Dir.pwd, 'hooks', '**', '*.rb')].each{ |f| require f }

available_hooks = Hooks.constants.reject{ |k| k == :Hook }


get '/' do
  'Huzzah!  If you see this page, then Viget Hookshot should be working correctly.'
end

namespace '/hooks' do
  before do
    ensure_from_github! unless settings.environment == :development
  end

  available_hooks.collect{ |k| Hooks.const_get(k) }.each do |klass|
    post "/#{klass.path}" do
      hook = klass.new(self)
      hook.process!

      logger.info "[#{hook}] completed processing"
    end
  end

  def ensure_from_github!
    unless env['HTTP_USER_AGENT'] =~ %r{\AGitHub Hookshot}
      halt 403, 'You are not permitted to make this request!'
    end
  end
end
