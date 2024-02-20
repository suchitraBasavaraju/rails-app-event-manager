class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create_event_a
    user = current_user
    Event.create(name: "Event A", user_id: user.id, event_type: "A")
    flash[:success] = 'Event A created!'
    redirect_to root_path
  end

  def create_event_b
    user = current_user
    Event.create(name: "Event B", user_id: user.id, event_type: "B")
    flash[:success] = 'Event B created!'
    redirect_to root_path
  end

  def send_email_notifications
    responses = []
    begin
      events_b = Event.where(event_type: 'B')
      events_b.each do |event|
        body = {
          campaignId: 0,
          recipientEmail: "string",
          recipientUserId: event.user_id.to_s,
          dataFields: { favoriteColor: "red" },
          sendAt: "string",
          allowRepeatMarketingSends: true,
          metadata: {}
        }
        response = IterableService.send_email_notification(body)
        responses << response
      end
      flash[:success] = responses
    rescue StandardError => e
      flash[:error] = "Error sending email notifications: #{e.message}"
    ensure
      redirect_to root_path
    end
  end
end
