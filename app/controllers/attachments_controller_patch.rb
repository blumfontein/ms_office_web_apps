module AttachmentsControllerPatch
  module InstanceMethods
    def download_with_message
      if @attachment.container.is_a?(Version) || @attachment.container.is_a?(Project)
        @attachment.increment_download
      end

      if stale?(:etag => @attachment.digest)
        extension = @attachment.filename.split('.').last

        # images and pdf files are sent inline
        send_file @attachment.diskfile, :filename => filename_for_content_disposition(@attachment.filename),
                                        :type => detect_content_type(@attachment),
                                        :disposition => (@attachment.image? || extension == 'pdf' ? 'inline' : 'attachment')
      end
    end
  end

  def self.included(receiver)
    receiver.send :include, InstanceMethods

    receiver.class_eval do
      alias_method_chain :download, :message
    end
  end
end