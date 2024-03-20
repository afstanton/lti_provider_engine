require 'spec_helper'

describe LtiProvider::Launch do
  describe ".initialize_from_request" do
    let(:provider) do
      p = double('provider')
      allow(p).to receive_messages(
        to_params: {
          'custom_canvas_course_id' => 1,
          'custom_canvas_user_id' => 2,
          'oauth_nonce' => 'nonce',
          'tool_consumer_instance_guid' => "123abc",
        },
        launch_presentation_return_url: "http://example.com",
        consumer_key: "key",
        consumer_secret: "secret",
        valid_request?: true,
        request_oauth_timestamp: Time.now
      )
      p
    end

    let(:request) do
      r = double('request')
      allow(r).to receive_messages(env: {'HTTP_REFERER' => "http://example.com"})
      r
    end

    subject(:launch) { LtiProvider::Launch.initialize_from_request(provider, request) }

    it "parses params" do
      expect(subject.course_id).to eq 1
      expect(subject.tool_consumer_instance_guid).to eq '123abc'
      expect(subject.user_id).to eq 2
      expect(subject.nonce).to eq 'nonce'
      expect(subject.account_id).to be_nil
      expect(subject.canvas_url).to eq 'http://example.com'
    end
  end

  describe "xml_config" do
    let(:lti_launch_url) { "http://example.com/launch" }
    let(:doc) { Nokogiri::XML(xml) }

    subject(:xml) { LtiProvider::Launch.xml_config(lti_launch_url) }

    it { is_expected.to match(/\<\?xml/) }

    it "includes the launch URL" do
      expect(doc.xpath('//blti:launch_url').text).to match lti_launch_url
    end

    it "includes the course_navigation option and url + text properties" do
      nav = doc.xpath('//lticm:options[@name="course_navigation"]')
      expect(nav.xpath('lticm:property[@name="url"]').text).to eq 'http://override.example.com/launch'
      expect(nav.xpath('lticm:property[@name="text"]').text).to eq "Dummy"
      expect(nav.xpath('lticm:property[@name="visibility"]').text).to eq "admins"
    end

    it "includes account_navigation" do
      nav = doc.xpath('//lticm:options[@name="account_navigation"]')
      expect(nav).to be_present
    end

    it "includes no user_navigation" do
      nav = doc.xpath('//lticm:options[@name="user_navigation"]')
      expect(nav).to be_empty
    end
  end
end
