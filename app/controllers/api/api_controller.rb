class Api::ApiController < ApplicationController
  # Skip authenticity token verification for API calls
  skip_before_action :verify_authenticity_token
  # Skip Devise authentication for the base API controller
  skip_before_filter :authenticate!

  def index
    
  end

  protected

    def response_errors(record)
      errors = []
      record.errors.messages.each do |key, value|
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