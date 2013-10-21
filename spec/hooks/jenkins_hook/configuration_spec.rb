require 'spec_helper'

describe Hooks::JenkinsHook::Configuration do
  context "with an instance of #{described_class.name}" do
    let(:base_config) {
      %q{
        url: ci.jenkins.org
        auth_token: 123456
      }
    }
    let(:yaml_config) { base_config }

    subject { described_class.new('ProjectName') }

    before do
      File.stub(:open) { StringIO.new(yaml_config.gsub(/\n\s*/, "\n")) }
    end

    describe "#url" do
      context "with username and password" do
        let(:yaml_config) {
          %Q{
            #{base_config}
            username: jenkies
            password: letmein
          }
        }

        it "returns url with authentication string" do
          expected = 'http://jenkies:letmein@ci.jenkins.org/job/ProjectName/build?token=123456'

          subject.url.should == expected
        end
      end

      context "with username only" do
        let(:yaml_config) {
          %Q{
            #{base_config}
            username: jenkies
            password:
          }
        }

        it "returns url without authentication string" do
          expected = 'http://ci.jenkins.org/job/ProjectName/build?token=123456'

          subject.url.should == expected
        end
      end

      context "with password only" do
        let(:yaml_config) {
          %Q{
            #{base_config}
            username:
            password: letmein
          }
        }

        it "returns url without authentication string" do
          expected = 'http://ci.jenkins.org/job/ProjectName/build?token=123456'

          subject.url.should == expected
        end
      end

      context "with no auth information" do
        it "returns url without authentication string" do
          expected = 'http://ci.jenkins.org/job/ProjectName/build?token=123456'

          subject.url.should == expected
        end
      end
    end
  end
end
