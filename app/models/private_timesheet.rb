class PrivateTimesheet < Timesheet

  def editable?(user)
    if user.admin? || self.user == user
      true
    else
      false
    end
  end

  def visible?(user)
    if self.user == user || user.admin?
      true
    else
      false
    end
  end
end
