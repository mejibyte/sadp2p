class SharedFilesController < ApplicationController
  def create
    client = Client.find_or_create_by_ip(request.remote_ip + ":" + params[:port])
    client.last_seen_at = Time.now
    client.shared_files = []
    client.save!
    
    params[:files].each do |attributes|
      shared_file = SharedFile.find_or_create_by_filename(attributes[:filename])
      shared_file.clients << client unless shared_file.client_ids.include?(client.id)
      shared_file.save!
    end
    render :json => '"OK"'
  end
  
  def show
    file = SharedFile.where(:filename => params[:filename]).first
    if file.present?
      render :json => file.clients.recent.collect(&:ip)
    else
      render :json => []
    end
  end

  def list
    params[:current_dir] ||= ""
    shared_files = SharedFile.where("filename LIKE '#{params[:current_dir]}%'").reject { |f| !f.current? }
    render :json => shared_files.collect(&:filename)
  end

  def index
    @shared_files = SharedFile.all
  end
end
