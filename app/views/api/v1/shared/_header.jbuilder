if !defined?(message)
  message = nil
end
if !defined?(errors)
  errors = nil
end
if !defined?(success) || success.nil?
  success = true
end

json.success success
json.message message unless message.nil?
json.errors errors unless errors.nil?