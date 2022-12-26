json.id user.to_param
json.type user.model_name
json.extract! user, :email
