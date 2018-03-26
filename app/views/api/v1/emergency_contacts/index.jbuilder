json.partial! "/api/v1/shared/header", success: true, message: @message
json.partial! "/api/v1/shared/emergency_contact_index", emergency_contacts: @emergency_contacts
