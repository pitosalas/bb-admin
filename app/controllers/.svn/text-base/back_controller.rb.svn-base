# This is the background tasks controller
class BackController < ApplicationController

  # Reports all expired paid plans for our detailed consideration
  def report_expired
    @users = User.find(:all, 
      :conditions => 'plan_price > 0 and plan_period_months > 0 and plan_exp_date <= now()',
      :order => 'plan_exp_date asc')
    render :layout => false
  end
  
  # Checks trial periods for expiration and reverts to the free plan when
  # expired
  def check_trials
    # Find a free plan to revert to
    p = Plan.find(:first, :conditions => 'price = 0', :limit => 1)
    if p
      # Revert every expired trial to the free plan
      @updated = User.update_all("plan_id = #{p.id}, plan_price = 0, plan_period_months = 0, plan_exp_date = null, plan_is_trial_used = 1, plan_is_trial = 0",
        'plan_is_trial = 1 and plan_exp_date <= now()')
      render :layout => false
    else
      render :text => "There's no free plan to revert trial plans to."
    end
  end
  
  # Reverts all expired plans to the free plan
  def revert_to_free
  end

end
