class WopiFilesContentsController < ApplicationController
  skip_before_filter :check_if_login_required, :check_password_change

  def get_file
    attachment = Attachment.find(params[:id])

    if stale?(:etag => attachment.digest)
      send_file attachment.diskfile, :filename => filename_for_content_disposition(attachment.filename),
                :type => detect_content_type(attachment),
                :disposition => 'attachment'
    end
  end

  def detect_content_type(attachment)
    content_type = attachment.content_type
    if content_type.blank?
      content_type = Redmine::MimeType.of(attachment.filename)
    end
    content_type.to_s
  end
end
