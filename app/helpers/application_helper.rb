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

  def t_holder(name, object)
    I18n.t name, scope: "placeholder.#{object.name.downcase}"
  end
  def t_view(name, object, option={})
    translate = "views.#{object.to_s.downcase}.#{option.try(:downcase).try(:to_s)}"
    I18n.t name, scope: translate.strip
  end

end