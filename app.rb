require 'sinatra'
require 'sinatra/namespace'

require_relative './hooks/jenkins_hook'

get '/' do
  'Huzzah!  If you see this page, then Viget Hookshot should be working correctly.'
end

namespace '/hooks' do
  before do
    ensure_from_github!
  end

  post '/jenkins' do
    hook = Hooks::JenkinsHook.new(self)
    hook.process!

    logger.info '[Jenkins Hook] completed processing'
  end

  def ensure_from_github!
    unless env['HTTP_USER_AGENT'] =~ %r{\AGitHub Hookshot}
      halt 403, 'You are not permitted to make this request!'
    end
  end
end
