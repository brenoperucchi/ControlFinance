class NoticePresenter
  def initialize(object)
    @notice = object
  end

  def to_json
    return json(@notice)
  end

  private
  def json(notice)
    if not notice.persisted?
      {
        error: true, 
        name: notice.class.name,
        message: "Double check your form before continuing."
      }
    else 
      {
        error: false, 
        name: notice.class.name,
        message: "Action was successfully done"
      }
    end
  end
end