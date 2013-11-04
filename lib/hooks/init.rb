require_relative '../hook'

Dir[File.join(Dir.pwd, 'lib', 'hooks', '**', '*.rb')].each{ |f| require f }
