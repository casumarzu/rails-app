json.array!(@photos) do |photo|
  json.extract! photo, :id, :title, :description, :image
  json.url photo_url(photo, format: :json)
end
