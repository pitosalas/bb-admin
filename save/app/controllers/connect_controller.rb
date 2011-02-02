class ConnectController < ApplicationController
  # Main page
  def index
    init_types_and_priorities
    @messages = Message.find(:all, :order => 'id DESC')
  end
  
  def init_types_and_priorities
    @types = ['What\'s New', 'Announcement', 'Tips and Tricks']
    @priorities = ['High', 'Normal', 'Low']
  end
  
  # Select a message for editing
  def edit
    @msg = Message.find(params[:id])
  end
  
  # Delete a message
  def delete
    @id = params[:id]
    Message.delete(@id)
  end
  
  # Cancel addition / modification
  def cancel
  end
  
  # Shows the form for adding a message
  def add
  end
  
  # Commits addition / modification
  def commit
    @new = false
    @saved = false
    
    if params[:maction] == 'edit'
      # Saving changes
      @msg = Message.find(params[:mid])
    else
      # Adding new
      @msg = Message.new
      @new = true
    end

    @msg.update_attributes(params[:message])
    @msg.save
    @saved = true
    
    init_types_and_priorities
    @row = render_to_string :partial => 'message_row', :object => @msg, :layout => false, :locals => { :adding => true }
  end
end
