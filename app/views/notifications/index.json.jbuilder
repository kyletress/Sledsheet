json.array! @notifications do |notification|
  json.actor notification.actor.name
  json.action notification.action
  json.notifiable do
     json.type "a #{notification.notifiable.class.to_s.underscore.humanize.downcase}"
  end
  json.url timesheet_path(notification.notifiable)
end
