class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_iterable_service,

  def index
  end

  def create_event_a
    user = current_user
    Event.create(name: "Event A", user_id: user.id, event_type: "A")
    event_a_response = @iterable_service.track_event("Event A", current_user.email)
    flash[:success] = "event A created"
  end

  def create_event_b
    user = current_user
    Event.create(name: "Event B", user_id: user.id, event_type: "B")

    event_a_response = @iterable_service.track_event("Event B", current_user.email)
    send_email_response = @iterable_service.send_email_notification(current_user.email)

    flash[:success] = "event B created"
    redirect_to root_path
  end

end
