require 'rails_helper'
require 'webmock/rspec'

RSpec.describe "EventsControllers", type: :request do

  let(:user) { create(:user) }
  before do
    Dotenv.load('.env')
    ENV['ITERABLE_IO_API_KEY'] = 'test-api-key'
    sign_in user

  end

  describe "POST #create_event_a" do

    it "creates an Event A" do
      url = /api\/events\/trackWebPushClick/
      WebMock.stub_request(:post, url).to_return(status: 200, body: `{ "msg" : "Event A" }`, headers: {})

      post "/events/create_event_a"

      expect(WebMock).to have_requested(:post, url).with(
        headers: { 'Authorization' => "Bearer test-api-key" ,'Content-Type'=>'application/json'},
        body: '{"email":"user@example.com","messageId":"Event A"}'
      ).once
    end

  end

  describe "POST #create_event_b" do

    it "creates an Event B and redirects to root_path" do
      expect {
        post "/events/create_event_b"
      }.to change(Event, :count).by(1)

      expect(flash[:success]).to eq('Event B created!')
      expect(response).to redirect_to(root_path)
      expect(Event.first.name).to eq("Event B")
      expect(Event.first.user_id).to eq(user.id)
      expect(Event.first.event_type).to eq("B")
    end
  end

  describe "#send_email_notifications" do
    it "sends email notifications for events of type 'B'" do
      allow(IterableService).to receive(:send_email_notification).and_return("mocked_response")
      Event.create(name: "Event A", user_id: 3, event_type: "A")
      Event.create(name: "Event B", user_id: 1, event_type: "B")
      Event.create(name: "Event B", user_id: 2, event_type: "B")

      post "/events/send_email_notifications"

      expect(response).to redirect_to(root_path)
      expect(flash[:success]).to eq(["mocked_response", "mocked_response"])
      expect(IterableService).to have_received(:send_email_notification).with(
        hash_including({ campaignId: 0, recipientEmail: "string", dataFields: { favoriteColor: "red" }, sendAt: "string", allowRepeatMarketingSends: true, metadata: {} })
      ).twice
    end
  end
end
