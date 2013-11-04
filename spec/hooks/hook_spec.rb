require 'spec_helper'

describe Hooks::Hook do
  subject { described_class.new(app) }

  describe "#process!" do
    it "raises NotImplementedError" do
      expect{ subject.process! }.to raise_error(NotImplementedError)
    end
  end
end
