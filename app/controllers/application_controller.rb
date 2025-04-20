# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp, web push, badges, import maps, CSS nesting, and :has
  allow_browser versions: :modern

  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    trips_path
  end

  # Redirects away if the current_user may not access this trip
  def authorize_trip!(trip)
    unless trip.accessible_by?(current_user)
      redirect_to trips_path, alert: "You don’t have access to that trip."
    end
  end
end
