class PhotoDecorator < ApplicationDecorator
  delegate_all

  def image
    h.image_tag model.image_url
  end
end
