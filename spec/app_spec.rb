require 'spec_helper'

describe "Main Application" do
  it "returns text for root route" do
    get '/'

    last_response.should be_ok
    last_response.body.should =~ /working correctly/
  end
end
