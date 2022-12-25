json.array! @sections do |section|
  json.merge! section
  json.items section[:items] do |item|
    json.partial! item
  end
end
