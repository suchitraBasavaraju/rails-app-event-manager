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
    responses =[]
    events_b = Event.where(event_type: 'B')
    events_b.each do |event|
      response = IterableService.send_email_notification(event.user_id.to_s, "subject", "body")
      responses << response
    end
      flash[:success] = responses
    redirect_to root_path
  end

end
