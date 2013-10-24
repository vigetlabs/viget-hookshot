require 'json'

Dir["#{settings.root}/hooks/jenkins_hook/**/*.rb"].each{ |f| require f }

module Hooks
  class JenkinsHook
    DEFAULT_BRANCHES = %w(master)

    @@path = 'jenkins'

    def self.path
      @@path
    end

    def initialize(application)
      @application = application
    end

    def process!
      if valid?
        trigger_build
        logger.info "[#{self}] #{payload_branch} was valid. Payload Delivered!"
      else
        logger.info "[#{self}] Payload was invalid. Payload Not Delivered!"
      end
    end

    def to_s
      'Jenkins Hook'
    end


    private

    def payload
      @payload ||= parse_payload(params[:payload])
    end

    def branches
      @branches ||= parse_branches(params[:branches])
    end

    #:nocov:
    def trigger_build
      `curl #{config.url}`
    end
    #:nocov:

    def valid?
      valid_payload? && valid_branch?
    end

    def parse_payload(payload)
      (payload =~ /\A{.*}\z/) ? JSON.parse(payload) : nil
    end

    def parse_branches(branches)
      branches.respond_to?(:split) ? branches.split(',') : DEFAULT_BRANCHES
    end

    def valid_payload?
      payload && payload_ref
    end

    def valid_branch?
      branches.include?(payload_branch)
    end

    def payload_branch
      @payload_branch ||= payload_ref.split('/').last
    end

    def payload_ref
      payload['ref']
    end

    def params
      @application.params
    end

    def logger
      @application.logger
    end

    def config
      @config ||= Configuration.new(params[:project])
    end
  end
end
