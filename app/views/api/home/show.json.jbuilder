json.array! @sections do |section|
  json.extract! section, :name, :href, :format
  json.items section.items do |item|
    json.partial! item
  end
end
