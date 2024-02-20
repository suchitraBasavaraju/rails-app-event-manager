require 'rails_helper'

RSpec.describe "EventsControllers", type: :request do

  let(:user) { create(:user) }
  before do
    sign_in user
  end

  describe "POST #create_event_a" do

    it "creates an Event A and redirects to root_path" do
      expect {
        post "/events/create_event_a"
      }.to change(Event, :count).by(1)

      expect(flash[:success]).to eq('Event A created!')
      expect(response).to redirect_to(root_path)
      expect(Event.first.name).to eq("Event A")
      expect(Event.first.user_id).to eq(user.id)
      expect(Event.first.event_type).to eq("A")
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
