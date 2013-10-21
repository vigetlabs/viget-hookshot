require 'json'

require_relative './jenkins_hook/configuration'

module Hooks
  class JenkinsHook
    attr_reader :payload, :branches

    DEFAULT_BRANCHES = %w(master)

    def initialize(application)
      @application = application
      @payload     = parse_payload(params[:payload])
      @branches    = parse_branches(params[:branches])
    end

    def valid?
      valid_payload? && valid_branch?
    end

    def process!
      if valid?
        trigger_build
        logger.info "[Jenkins Hook] #{payload_branch} was valid. Payload Delivered!"
      else
        logger.info "[Jenkins Hook] Payload was invalid. Payload Not Delivered!"
      end
    end


    private

    #:nocov:
    def trigger_build
      `curl #{config.url}`
    end
    #:nocov:

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
      Configuration.new(params[:project])
    end
  end
end
