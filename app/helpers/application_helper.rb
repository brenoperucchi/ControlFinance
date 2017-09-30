module ApplicationHelper
  def xeditable? object = nil
    true # Or something like current_user.xeditable?
  end

  def namespace
    if self.class.parent == "admin"
      "admin"
    else
      "user"
    end
  end

  def localize(object, options={})
    I18n.l object, options if object
  end

  def image_url(object, options={})
    super if object.present?
  end

end