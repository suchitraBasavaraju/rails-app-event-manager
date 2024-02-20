class ApplicationController < ActionController::Base
  def initialize_iterable_service
    @iterable_service ||= IterableService.new(ENV['ITERABLE_IO_URL'], ENV['ITERABLE_IO_API_KEY'])
  end
end
