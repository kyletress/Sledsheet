class SharedTimesheet < ApplicationRecord
  belongs_to :user
  belongs_to :shared_user, class_name: "User", foreign_key: "shared_user_id"
  belongs_to :timesheet

  validates :user_id, :timesheet_id, :shared_email, presence: true
  validates :shared_user_id, uniqueness: { scope: :timesheet_id }, allow_blank: true
end
