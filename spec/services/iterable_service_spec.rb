require 'rails_helper'
RSpec.describe 'IterableService' do

  let(:track_event_url) { %r{/api/events/track} }
  let(:email_target_url) { %r{/api/email/target} }

  describe "send email notification" do

    it "send email notification successfully" do
      WebMock.stub_request(:post, email_target_url).to_return(status: 200, body: `{ "campaignId" : 0, "recipientEmail": "Event A" }`, headers: {})

      email = "user@example.com"
      response = IterableService.send_email_notification(email)

      expect(response).to eq("Email Notification sent")
    end

    it "send notification failed with bad request" do
      WebMock.stub_request(:post, email_target_url).to_return(status: 400, body: `{ "error" : "Event B creation" }`, headers: {})

      email = "user@example.com"
      expect {
        IterableService.send_email_notification(email) }.to raise_error("Email Notification Failed,Error: 400")
    end

    it "send notification failed with access failure" do
      WebMock.stub_request(:post, email_target_url).to_return(status: 401, body: `{ "error" : "Forbidden" }`, headers: {})
      email = "user@example.com"

      expect {
        IterableService.send_email_notification(email) }.to raise_error("Email Notification Failed,Error: 401")
    end
  end

  describe "create event" do

    it "create Event successfully" do
      WebMock.stub_request(:post, track_event_url).to_return(status: 200, body: `{ "msg" : "Event A" ,"code" : "Success", "params":{}`, headers: {})
      email = "user@example.com"

      response = IterableService.track_event("Event A", email)

      expect(WebMock).to have_requested(:post, track_event_url).with(body: { "email" => email, "eventName" => "Event A" }.to_json, headers: { 'authorization': 'Bearer 123456' })
      expect(response).to eq("Event A sent")
    end

    it "create Event successfully" do
      WebMock.stub_request(:post, track_event_url).to_return(status: 200, body: `{ "msg" : "Event A" ,"code" : "Success", "params":{}`, headers: {})
      email = "user@example.com"

      response = IterableService.track_event("Event A", email)

      expect(WebMock).to have_requested(:post, track_event_url).with(body: { "email" => email, "eventName" => "Event A" }.to_json, headers: { 'authorization': 'Bearer 123456' })
      expect(response).to eq("Event A sent")
    end

    it "create Event failed for bad request" do
      WebMock.stub_request(:post, track_event_url).to_return(status: 400, body: `{ "msg" : "Event A" }`, headers: {})
      email = "user@example.com"

      expect {
        IterableService.track_event("Event A", email) }.to raise_error("Event Creation Failed,Error: 400")
    end

    it "create Event failed for access issue" do
      WebMock.stub_request(:post, track_event_url).to_return(status: 401, body: `{ "msg" : "Event A" }`, headers: {})
      email = "user@example.com"

      expect {
        IterableService.track_event("Event A", email) }.to raise_error("Event Creation Failed,Error: 401")
    end
  end
end
