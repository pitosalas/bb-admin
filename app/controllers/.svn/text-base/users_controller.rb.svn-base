class UsersController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @user_pages, @users = paginate :users, :per_page => 40, :conditions => fetch_conditions
  end

  def list_excel
    @users = User.find_by_sql("select u.*, p.name as plan_name from Users u left join plans p on u.plan_id=p.id where #{fetch_conditions}")
    headers['Content-Type'] = 'application/vnd.ms-excel;charset=UTF-8'
    headers['Content-Disposition'] = 'filename=users.csv'
    render :layout => false
  end
  
  # Lists inactive users
  def unactivated
    date_limit = Date.today - 14
    cond = "activated = 0 and registrationDate < '#{date_limit.to_date}'"
    @user_pages, @users = paginate :users, :per_page => 40, :conditions => cond
  end
  
  def unactivated_page
    unactivated
    render :partial => "unactivated_users"
  end

  # Shows the change plan page
  def change_plan
    @user = User.find(params[:id])
  end
  
  # Grants unlimited plan to a user
  def grant_unlimited
    u = User.find(params[:id])
    u.plan_id = params[:plan][:id];
    u.plan_exp_date = nil
    u.plan_price = nil
    u.plan_period_months = nil
    u.plan_is_trial = false
    u.save
    
    @user = u
    render "users/change_plan"
  end
  
  # Grants a trial for the max plan
  def grant_trial
    u = User.find(params[:id])
    u.plan = Plan.find(:first, :order => 'price DESC')
    u.plan_exp_date = Date.civil(params[:date][:year].to_i, params[:date][:month].to_i, params[:date][:day].to_i)
    u.plan_price = nil
    u.plan_period_months = nil
    u.plan_is_trial = true
    u.save
    
    @user = u
    render "users/change_plan"
  end
  
  # Changes the plan filter and reloads the users list
  def filter
    session[:filter_id] = (params[:filter_id] || -1)
    session[:name] = (params[:user_name] || '')
    change_page
  end
  
  def change_page
    @user_pages, @users = paginate :users, :per_page => 40, :conditions => fetch_conditions
    render :partial => "show_users"
  end

  # Returns user list fetch conditions basing on current session
  # properties.  
  def fetch_conditions
    fid = session[:filter_id] || '-1'
    fid = fid.to_i
    
    name = session[:name] || ''
    cond = Array.new()
    case
      when fid > -1
        cond << "plan_id = #{fid}"
      when fid == -2
        cond << "pp_subid IS NOT NULL"
      when fid == -3
        cond << "plan_is_trial = 1 AND plan_exp_date >= NOW()"
      else
        cond << "1=1"
    end
    cond << "(fullName LIKE '%#{name}%' OR email LIKE '%#{name}%')" if name != ''
    
    return cond.join(" and ");
  end
  
  # Toggles the trial-used flag of the user and renders the trial-used partial.
  def toggle_trial_used
    u = User.find(params[:id])
    u.plan_is_trial_used = !u.plan_is_trial_used
    u.save
    
    render :partial => "trial_used", :object => u
  end
  
  # Deletes given user
  def delete
    User.delete(params[:id])
    index
  end
end
