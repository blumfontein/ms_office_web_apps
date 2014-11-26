# Ms Office Web Apps plugin's routes

get 'wopi/files/:id', :to => 'wopi_files#check_file_info'
get 'wopi/files/:id/contents', :to => 'wopi_files_contents#get_file', :as => 'wopi_get_file'