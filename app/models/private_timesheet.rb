class PrivateTimesheet < Timesheet
  def short_name
    "Private Timesheet"
  end

  def editable?(user)
    if user.admin? || self.user == user
      true
    else
      false
    end
  end
end
