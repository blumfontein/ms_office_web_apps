class WopiFilesContentsController < ApplicationController
  skip_before_filter :check_if_login_required, :check_password_change

  def get_file
    attachment = Attachment.find(params[:id])

    redirect_to send('download_named_attachment_path', attachment, attachment.filename)
  end
end
