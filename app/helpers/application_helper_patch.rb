module ApplicationHelperPatch
  module InstanceMethods
    def link_to_attachment_with_message(attachment, options={})
      text = options.delete(:text) || attachment.filename
      route_method = options.delete(:download) ? :download_named_attachment_path : :named_attachment_path
      html_options = options.slice!(:only_path)

      extension = attachment.filename.split('.').last

      web_apps_url = ''
      owa_domain = Setting.plugin_ms_office_web_apps['owa_host']

      if ['doc', 'docx'].include? extension
        web_apps_url = owa_domain + '/wv/wordviewerframe.aspx?WOPISrc='
      elsif ['ppt', 'pptx'].include? extension
        web_apps_url = owa_domain + '/p/PowerPointFrame.aspx?PowerPointView=ReadingView&WOPISrc='
      elsif ['xls', 'xlsx'].include? extension
        web_apps_url = owa_domain + '/x/_layouts/xlviewerinternal.aspx?WOPISrc='
      end

      if web_apps_url != ''
        require 'open-uri'
        host = request.nil? ? '' : request.protocol + request.host_with_port
        url = web_apps_url + URI::encode(host + '/wopi/files/' + attachment.id.to_s)
        html_options[:target] = '_blank'
      else
        url = send(route_method, attachment, attachment.filename, options)
      end

      download_url = send('wopi_get_file_path', attachment)
      link_to(text, url, html_options) + ' ' + link_to(image_tag('download.png', :plugin => 'ms_office_web_apps'), download_url, {:title => t(:button_download)})
    end
  end

  def self.included(receiver)
    receiver.send :include, InstanceMethods

    receiver.class_eval do
      alias_method_chain :link_to_attachment, :message
    end
  end
end