json.id user.to_param
json.type user.model_name
json.extract! user, :name
json.extract! user, :email if user == current_user
