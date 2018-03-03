class Api::ApiController < ApplicationController
  # Skip authenticity token authentication for the Base API
  skip_before_action :verify_authenticity_token
  # Skip authentication on the API root
  # skip_before_action :authenticate!

  after_action :check_for_callback

  helper_method :current_user

  def index

  end

  protected

  # Check for callback
  def check_for_callback
    params[:format] = "json" if params[:format].nil?
    if !params[:callback].blank? && params[:format] == "json"
      response.content_type = "text/javascript"
      response.body = "#{params[:callback]}(#{response.body})"
    end
  end

  # Return errors via the API more easily
  def response_errors(record)
    errors = []
    record.errors.messages.each do |key,value|
      if key == :base
        key = ""
      else
        key = key.to_s.humanize
      end
      errors << "#{key} #{value.join(', ')}"
    end
    errors
  end
end
