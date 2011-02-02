class ErrorsController < ApplicationController

  # Builds the index page
  def index
    @summary = ClientError.summary
    fetch_errors
  end

  # Fetches errors list
  def fetch_errors
    @errors = ClientError.groups 0, 10, fetch_conditions
  end
  
  # Returns fetch conditions basing on current filters
  def fetch_conditions
    ver = session[:version] || ''
    return (ver != '') ? "version = '#{ver}'" : ''
  end
  
  # Deletes an error group and renders the updated errors partial
  def delete
    ClientError.delete_similar(params[:id])

    fetch_errors
    render(:partial => "errors", :layout => false)
  end
  
  # Deletes all messages for the given version
  def delete_version
    ClientError.delete_version(params[:version])
    index
    render :action => 'index'
  end
  
  # Returns details for the error
  def details
    render :text => ClientError.find(params[:id]).details
  end
  
  # Sets the version filter value and renders errors partial
  def set_version_filter
    session[:version] = params[:version]
    fetch_errors
    render(:partial => "errors", :layout => false)
  end

end
