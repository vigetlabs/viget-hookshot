shared_examples_for "a github hook" do
  context "when testing headers" do
    let(:request) { lambda { post "/hooks#{path}", {}, headers }}

    context "when User Agent is GitHub Hookshot" do
      let(:headers) { { 'HTTP_USER_AGENT' => 'GitHub Hookshot xxxxxxx' }}

      it "responds with success" do
        described_class.any_instance.should_receive(:process!)

        request.call

        last_response.should be_ok
      end
    end

    context "when User Agent is not GitHub Hookshot" do
      let(:headers) { { 'HTTP_USER_AGENT' => 'Malicious Max' }}

      it "responds with forbidden" do
        described_class.any_instance.should_not_receive(:process!)

        request.call

        last_response.status.should == 403
        last_response.body.should =~ /not permitted/
      end
    end
  end
end
