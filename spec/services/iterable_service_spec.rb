require 'rails_helper'
RSpec.describe 'IterableService' do

  describe "send email notification" do
    before do
      @send_email_url = /api\/email\/target/
    end

    it "send email notification successfully" do
      WebMock.stub_request(:post, @send_email_url).to_return(status: 200, body: `{ "campaignId" : 0, "recipientEmail": "Event A" }`, headers: {})

      email = "user@example.com"
      response = IterableService.send_email_notification(email)

      expect(response).to eq("Email Notification sent")
    end

    it "send notification failed with bad request" do
      WebMock.stub_request(:post, @send_email_url).to_return(status: 400, body: `{ "error" : "Event B creation" }`, headers: {})

      email = "user@example.com"
      expect {
        IterableService.send_email_notification(email) }.to raise_error("Email Notification Failed,Error: 400")
    end

    it "send notification failed with access failure" do
      WebMock.stub_request(:post, @send_email_url).to_return(status: 401, body: `{ "error" : "Forbidden" }`, headers: {})
      email = "user@example.com"

      expect {
        IterableService.send_email_notification(email) }.to raise_error("Email Notification Failed,Error: 401")
    end
  end

  describe "create event" do

    before do
      @url = /api\/events\/track/
    end

    it "create Event successfully" do
      WebMock.stub_request(:post, @url).to_return(status: 200, body: `{ "msg" : "Event A" }`, headers: {})
      email = "user@example.com"

      response = IterableService.track_event("Event A", email)

      expect(response).to eq("Event A sent")
    end

    it "create Event failed for bad request" do
      WebMock.stub_request(:post, @url).to_return(status: 400, body: `{ "msg" : "Event A" }`, headers: {})
      email = "user@example.com"
      expect {
        IterableService.track_event("Event A", email) }.to raise_error("Event Creation Failed,Error: 400")
    end

    it "create Event failed for access issue" do
      WebMock.stub_request(:post, @url).to_return(status: 401, body: `{ "msg" : "Event A" }`, headers: {})
      email = "user@example.com"

      expect {
        IterableService.track_event("Event A", email) }.to raise_error("Event Creation Failed,Error: 401")
    end
  end
end
