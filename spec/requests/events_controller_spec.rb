require 'rails_helper'

RSpec.describe "EventsControllers", type: :request do

  let(:user) { create(:user) }
  before do
    Dotenv.load('.env')
    ENV['ITERABLE_IO_API_KEY'] = 'test-api-key'
    sign_in user
  end

  describe "POST #create_event_a" do

    it "creates an Event A" do
      event_web_push_url = /api\/events\/track/
      WebMock.stub_request(:post, event_web_push_url).to_return(status: 200, body: `{ "msg" : "Event A" }`, headers: {})

      post "/events/create_event_a"

      expect(WebMock).to have_requested(:post, event_web_push_url).with(
        headers: { 'Authorization' => "Bearer test-api-key", 'Content-Type' => 'application/json' },
        body: { 'email' => "user@example.com", 'eventName' => "Event A" }
      ).once
      expect(flash[:success]).to eq('Event A sent')
    end

    it "Event A creation api return bad request" do
      event_web_push_url = /api\/events\/track/
      WebMock.stub_request(:post, event_web_push_url).to_return(status: 400, body: `{ "error" : "Event A creation" }`, headers: {})

      post "/events/create_event_a"

      expect(WebMock).to have_requested(:post, event_web_push_url).with(
        headers: { 'Authorization' => "Bearer test-api-key", 'Content-Type' => 'application/json' },
        body: { 'email' => "user@example.com", 'eventName' => "Event A" }
      ).once
      expect(flash[:success]).to eq('Event A Failed. Error: 400')
    end

    it "Event A creation api return forbidden" do
      event_web_push_url = /api\/events\/track/
      WebMock.stub_request(:post, event_web_push_url).to_return(status: 401, body: `{ "error" : "Invalid API Key" }`, headers: {})

      post "/events/create_event_a"

      expect(WebMock).to have_requested(:post, event_web_push_url).with(
        headers: { 'Authorization' => "Bearer test-api-key", 'Content-Type' => 'application/json' },
        body: { 'email' => "user@example.com", 'eventName' => "Event A" }
      ).once
      expect(flash[:success]).to eq('Event A Failed. Error: 401')
    end
  end

  describe "POST #create_event_b and send email" do

    it "creates an Event B" do
      event_web_push_url = /api\/events\/track/
      email_send_url = /api\/email\/target/
      WebMock.stub_request(:post, event_web_push_url).to_return(status: 200, body: `{ "msg" : "Event B" }`, headers: {})
      WebMock.stub_request(:post, email_send_url).to_return(status: 200, body: `{ "campaignId" : 0, "recipientEmail": "user@example.com" }`, headers: {})

      post "/events/create_event_b"

      expect(WebMock).to have_requested(:post, event_web_push_url).with(
        headers: { 'Authorization' => "Bearer test-api-key", 'Content-Type' => 'application/json' },
        body: { 'email' => "user@example.com", 'eventName' => "Event B" }
      ).once

      expect(WebMock).to have_requested(:post, email_send_url).with(
        headers: { 'Authorization' => "Bearer test-api-key", 'Content-Type' => 'application/json' },
        body: { 'campaignId' => 0, 'recipientEmail' => 'user@example.com' }
      ).once

      expect(flash[:success]).to eq('Event B sent - Email Notification sent')
    end

    it "Email target failed with bad request" do
      event_web_push_url = /api\/events\/track/
      email_send_url = /api\/email\/target/
      WebMock.stub_request(:post, event_web_push_url).to_return(status: 200, body: `{ "msg" : "Event B" }`, headers: {})
      WebMock.stub_request(:post, email_send_url).to_return(status: 400, body: `{ "campaignId" : 0, "recipientEmail": "user@example.com" }`, headers: {})

      post "/events/create_event_b"

      expect(WebMock).to have_requested(:post, event_web_push_url).with(
        headers: { 'Authorization' => "Bearer test-api-key", 'Content-Type' => 'application/json' },
        body: { 'email' => "user@example.com", 'eventName' => "Event B" }
      ).once

      expect(WebMock).to have_requested(:post, email_send_url).with(
        headers: { 'Authorization' => "Bearer test-api-key", 'Content-Type' => 'application/json' },
        body: { 'campaignId' => 0, 'recipientEmail' => 'user@example.com' }
      ).once

      expect(flash[:success]).to eq('Event B sent - Email Notification failed: 400')
    end

    it "Email target failed with authentication failure" do
      event_web_push_url = /api\/events\/track/
      email_send_url = /api\/email\/target/
      WebMock.stub_request(:post, event_web_push_url).to_return(status: 200, body: `{ "msg" : "Event B" }`, headers: {})
      WebMock.stub_request(:post, email_send_url).to_return(status: 401, body: `{ "campaignId" : 0, "recipientEmail": "user@example.com" }`, headers: {})

      post "/events/create_event_b"

      expect(WebMock).to have_requested(:post, event_web_push_url).with(
        headers: { 'Authorization' => "Bearer test-api-key", 'Content-Type' => 'application/json' },
        body: { 'email' => "user@example.com", 'eventName' => "Event B" }
      ).once

      expect(WebMock).to have_requested(:post, email_send_url).with(
        headers: { 'Authorization' => "Bearer test-api-key", 'Content-Type' => 'application/json' },
        body: { 'campaignId' => 0, 'recipientEmail' => 'user@example.com' }
      ).once

      expect(flash[:success]).to eq('Event B sent - Email Notification failed: 401')
    end

  end

end
