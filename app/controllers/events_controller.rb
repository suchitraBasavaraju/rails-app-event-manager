class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create_event_a
    user = current_user
    Event.create(name: "Event A", user_id: user.id, event_type: "A")
    response = IterableService.track_event("Event A", current_user.email)
    flash[:success] = response
  end

  def create_event_b
    user = current_user
    Event.create(name: "Event B", user_id: user.id, event_type: "B")
    response_event_b = IterableService.track_event("Event B", current_user.email)
    flash[:success] = response
    response_notification = IterableService.send_email_notification(current_user.email)
    combined_response = "#{response_event_b} - #{response_notification}"
    flash[:success] = combined_response
  end

end
