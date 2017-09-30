module Admin::ProposalsHelper

  def helper_current_li(default, kind)
    if params[:scope] == kind.to_s
      "active" 
    elsif params[:scope].blank? and default
      "active" 
    end
  end
end  