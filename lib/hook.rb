class Hook
  def self.hook_at(path)
    self.define_singleton_method :path do
      path.to_s
    end
  end


  def initialize(application)
    @application = application
  end

  def process!
    raise NotImplementedError
  end

  def to_s
    self.class.name.demodulize.titleize
  end


  private

  def params
    @application.params
  end

  def logger
    @application.logger
  end
end
