class PublicTimesheet < Timesheet
  def visible?(user)
    true
  end

  def editable?(user)
    if user.admin?
      true
    else
      false
    end
  end
end
