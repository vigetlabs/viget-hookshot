require 'spec_helper'

describe Hooks::JenkinsHook do
  it_behaves_like "a github hook" do
    let(:path) { '/jenkins' }
  end

  context "with an instance of #{described_class.name}" do
    let(:logger) { double }
    let(:params) { {} }

    subject { described_class.new(app) }

    before do
      app.stub(:logger) { logger }
      app.stub(:params) { params }
    end

    describe "parsing branches" do
      context "when no branch is specified" do
        it "returns default branches" do
          subject.branches.should == described_class::DEFAULT_BRANCHES
        end
      end

      context "when one branch is specified" do
        let(:params) { { branches: 'feature' }}

        it "returns the specified branch" do
          subject.branches.should == %w(feature)
        end
      end

      context "when multiple branches are specified" do
        let(:params) { { branches: 'feature1,feature_2,feature-3' }}

        it "returns all specified branches split on comma" do
          subject.branches.should == %w(feature1 feature_2 feature-3)
        end
      end
    end

    describe "parsing payload" do
      context "when no payload is given" do
        it "returns nil" do
          subject.payload.should be_nil
        end
      end

      context "with improperly formatted JSON" do
        let(:params) { { payload: '{lolhakked' }}

        it "returns nil" do
          subject.payload.should be_nil
        end
      end

      context "with proper JSON" do
        let(:params) { { payload: %q[{"ref":"refs/heads/master"}] }}

        it "returns hash" do
          subject.payload.should == { 'ref' => 'refs/heads/master' }
        end
      end
    end

    describe "#process!" do
      before { subject.stub(:trigger_build) { true } }

      context "when valid" do
        let(:params) { { payload: %q[{"ref":"refs/heads/master"}], branches: 'master' }}

        it "writes success message to logger" do
          logger.should_receive(:info).with(/Payload Delivered!\z/)

          subject.process!
        end
      end

      context "when invalid" do
        it "writes failed message to logger" do
          logger.should_receive(:info).with(/Payload Not Delivered!\z/)

          subject.process!
        end
      end
    end

    describe "#config" do
      let(:params) { { project: 'Project' }}

      it "returns instance of Configuration" do
        subject.send(:config).should be_instance_of(described_class::Configuration)
      end
    end
  end
end
