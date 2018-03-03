json.partial! "/api/v1/shared/header", success: @success, message: @message, errors: @errors
json.ids @ids unless @ids.nil?