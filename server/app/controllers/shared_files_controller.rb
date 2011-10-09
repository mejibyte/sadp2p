class SharedFilesController < ApplicationController
  def create
    client = Client.find_or_create_by_ip(request.remote_ip)
    client.last_seen_at = Time.now
    client.shared_files = []
    client.save!
    
    params[:files].each do |attributes|
      shared_file = SharedFile.find_or_create_by_filename(attributes[:filename])
      shared_file.clients << client unless shared_file.client_ids.include?(client.id)
      shared_file.save!
    end
    render :json => "OK"
  end

  def search
  end

  def index
    @shared_files = SharedFile.all
  end
end
