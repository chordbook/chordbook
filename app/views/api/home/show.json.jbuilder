json.array! @sections do |section|
  json.extract! section, :name, :format
  json.href section[:href]
  json.items section[:items] do |item|
    json.partial! item
  end
end
