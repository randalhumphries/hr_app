class Api::V1Controller < ApplicationController
  # Authenticate with Doorkeeper unless the user is already authenticated via Devise
  before_action :doorkeeper_authorize!, unless: :user_signed_in?

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def index
    success
  end

  def test_not_found
    not_found
  end

  def test_not_authorized
    not_authorized
  end

  def test_application_error
    application_error
  end

  protected

  def success(message=nil)
    message = "Success" if message.blank?
    render_response(success: true, code: 200, message: message)
  end

  def application_error(message=nil)
    message = "Application Error" if message.blank?
    render_response(success: false, code: 500, message: message)
  end

  def not_found(message=nil)
    message = "Not Found." if message.blank?
    render_response(success: false, code: 404, message: message)
  end

  def not_authorized(message=nil)
    message = "Not Authorized" if message.blank?
    render_response(success: false, code: 401, message: message)
  end

  def render_response(opts={})
    @success = opts.fetch(:success, true)
    @errors = opts.fetch(:errors, nil)
    @message = opts.fetch(:message, nil)
    @ids = opts.fetch(:ids, nil)
    @code = opts.fetch(:code, 200)
    @code = 200 if @success == true
    render "/api/v1/shared/generic_response", status: @code
  end

  def current_resource_owner
    # If the 'doorkeeper_token' object exists, find the current user using the 'resource_owner_id'
    # attribute of the 'doorkeeper_token' object. If it doesn't exist, return the Devise current_user object
    @current_resource_owner ||= doorkeeper_token ? User.find(doorkeeper_token.resource_owner_id) : current_user
  end
end
