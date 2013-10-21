require 'yaml'

module Hooks
  class JenkinsHook
    class Configuration
      attr_reader :project

      def initialize(project)
        @project = project
      end

      def url
        "http://#{authentication_string}#{base_url}/job/#{project}/build?token=#{auth_token}"
      end

      def authentication_string
        "#{username}:#{password}@" if username? && password?
      end

      def base_url
        @url ||= ENV['JENKINS_URL'] || file_contents['url']
      end

      def username
        @username ||= ENV['JENKINS_USERNAME'] || file_contents['username']
      end

      def username?
        field_present?(username)
      end

      def password
        @password ||= ENV['JENKINS_PASSWORD'] || file_contents['password']
      end

      def password?
        field_present?(password)
      end

      def auth_token
        @auth_token ||= ENV['JENKINS_AUTH_TOKEN'] || file_contents['auth_token']
      end


      private

      def field_present?(field)
        field.respond_to?(:blank?) ? field.blank? : field
      end

      def file_contents
        YAML.load File.open("#{Dir.pwd}/config/jenkins.yml")
      end
    end
  end
end
