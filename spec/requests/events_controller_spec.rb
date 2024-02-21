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

    it 'sets error when track_event raises error' do
      allow(IterableService).to receive(:track_event).and_raise(StandardError, 'Error message')

      post "/events/create_event_a"

      expect(flash[:success]).to be_nil
      expect(flash[:error]).to eq('Error message')
    end
  end

  describe '#create_event_b and send email' do
    it 'creates Event B and sends email successfully' do
      allow(IterableService).to receive(:track_event).and_return("Event A tracked successfully") # Mocking IterableService
      allow(IterableService).to receive(:send_email_notification).and_return("Email Sent successfully") # Mocking IterableService

      post "/events/create_event_b"

      expect(flash[:success]).to eq("Event A tracked successfully - Email Sent successfully")
    end

    it 'sets error when track_event raises error' do
      allow(IterableService).to receive(:track_event).and_raise(StandardError, 'event error message')
      allow(IterableService).to receive(:send_email_notification).and_raise(StandardError, 'Email error message')

      post "/events/create_event_b"

      expect(flash[:success]).to be_nil
      expect(flash[:error]).to eq('event error message')
    end

    it 'sets error when send_email_notification raises error' do
      allow(IterableService).to receive(:track_event).and_return("Event A tracked successfully") # Mocking IterableService
      allow(IterableService).to receive(:send_email_notification).and_raise(StandardError,"Email send error") # Mocking IterableService


      post "/events/create_event_b"

      expect(flash[:error]).to eq('Email send error')
    end
  end
end
