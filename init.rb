Redmine::Plugin.register :ms_office_web_apps do
  name 'Ms Office Web Apps plugin'
  author 'Ilyas Makashev'
  description 'Redmine plugin for viewing Word, Excel and PowerPoint files in browser through Microsoft Office Web Apps'
  version '1.0.0'
  url 'https://github.com/blumfontein/ms_office_web_apps'

  settings :default => {'OWA host' => {}}, :partial => 'settings/ms_office_web_apps'
end

require_dependency 'application_helper'

Rails.configuration.to_prepare do
  ApplicationHelper.send :include, ApplicationHelperPatch
end