class WopiFilesController < ApplicationController
  skip_before_filter :check_if_login_required, :check_password_change

  def check_file_info
    attachment = Attachment.find(params[:id])

    render :json => {
        :BaseFileName => attachment.filename,
        :OwnerId => attachment.author_id,
        :Size => attachment.filesize,
        :Version => Time.now.to_i,
        :DownloadUrl => request.protocol + request.host_with_port + '/wopi/files/' + attachment.id.to_s + '/contents'
    }.to_json
  end
end
