require 'rails_helper'

RSpec.describe "EventsControllers", type: :request do

  let(:user) { create(:user) }
  before do
    sign_in user
  end

  describe '#create_event_a' do
    it 'creates Event A and tracks the event' do
      allow(IterableService).to receive(:track_event).and_return("Event A tracked successfully") # Mocking IterableService

      post "/events/create_event_a"

      expect(flash[:success]).to eq("Event A tracked successfully")
    end
  end

  describe '#create_event_b and send email' do
    it 'creates Event A and tracks the event' do
      allow(IterableService).to receive(:track_event).and_return("Event A tracked successfully") # Mocking IterableService
      allow(IterableService).to receive(:send_email_notification).and_return("Email Sent successfully") # Mocking IterableService

      post "/events/create_event_b"

      expect(flash[:success]).to eq("Event A tracked successfully - Email Sent successfully")
    end
  end
end
