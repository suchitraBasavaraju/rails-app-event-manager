require 'rails_helper'

RSpec.describe "Events request", type: :request do

  let(:user) { create(:user) }
  let(:track_event_url) { %r{/api/events/track} }
  let(:email_target_url) { %r{/api/email/target} }

  before do
    sign_in user
  end

  describe '#create_event_a' do
    it 'creates Event A and tracks the event' do
      WebMock.stub_request(:post, track_event_url).to_return(status: 200, body: `{ "msg" : "Event A" }`, headers: {})

      post "/events/create_event_a"

      expect(flash[:success]).to eq("Event A sent")
    end

    it 'Event A creation failed' do
      WebMock.stub_request(:post, track_event_url).to_return(status: 400)

      post "/events/create_event_a"

      expect(flash[:error]).to eq("Event Creation Failed,Error: 400")
    end
  end

  describe '#create_event_b and send email event' do
    it 'creates Event A and tracks the event' do
      WebMock.stub_request(:post, track_event_url).to_return(status: 200, body: `{ "msg" : "Event B" }`, headers: {})
      WebMock.stub_request(:post, email_target_url).to_return(status: 200, body: `{ "campaignId" : 0, "recipientEmail": "user@example.com" }`, headers: {})

      post "/events/create_event_b"

      expect(flash[:success]).to eq("Event B sent - Email Notification sent")
    end

    it 'creates Event B failed' do
      WebMock.stub_request(:post, track_event_url).to_return(status: 400)
      WebMock.stub_request(:post, email_target_url).to_return(status: 200, body: `{ "campaignId" : 0, "recipientEmail": "user@example.com" }`, headers: {})

      post "/events/create_event_b"

      expect(flash[:error]).to eq("Event Creation Failed,Error: 400")
    end

    it 'Email target failed for event B' do
      WebMock.stub_request(:post, track_event_url).to_return(status: 200, body: `{ "msg" : "Event B" }`, headers: {})
      WebMock.stub_request(:post, email_target_url).to_return(status: 400)

      post "/events/create_event_b"

      expect(flash[:error]).to eq("Email Notification Failed,Error: 400")
    end
  end
end