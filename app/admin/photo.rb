ActiveAdmin.register Photo do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end
  index do
    column "ID" do |photo|
      link_to photo.id, admin_photo_path(photo)
    end
    column :title
    column :description
    column :image do |photo|
      image_tag photo.image.thumb
    end
    actions
  end

  permit_params :title, :description, :image
  form(:html => { :multipart => true }) do |f|
    f.inputs "Create Product..." do
      f.input :title
      f.input :description
      f.input :image, :as => :file
      # f.input :image, :as => :file, :hint => f.template.image_tag(f.object.image.url(:thumb))
    end
    f.actions
  end
end
