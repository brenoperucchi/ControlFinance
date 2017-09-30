module Lib::Personhood

  def owner?
    department == "owner"
  end

  def admin?
    department == "admin"
  end

  def person?
    person_type == "person"
  end

  def company?
    person_type == "company"
  end

end