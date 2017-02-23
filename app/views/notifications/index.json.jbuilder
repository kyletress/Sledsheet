json.array! @notifications do |notification|
  json.id notification.id
  json.unread !notification.read_at?
  json.template render partial: "notifications/#{notification.notifiable_type.underscore.pluralize}/#{notification.action}", locals: {notification: notification}, formats: [:html]

  # json.actor notification.actor.name
  # json.action notification.action
  # json.notifiable do
  #    json.type "a #{notification.notifiable.class.to_s.underscore.humanize.downcase}"
  # end
  # json.url timesheet_path(notification.notifiable)
end
