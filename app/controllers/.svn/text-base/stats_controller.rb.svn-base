class StatsController < ApplicationController
  def index
    @plans = Plan.find_all
    @paying_users = User.connection().select_value("select count(*) from Users where pp_subid IS NOT NULL").to_i
    @monthly_income = User.connection().select_value("select sum(plan_price / plan_period_months) from Users where plan_price > 0 and plan_period_months > 0")
    @monthly_income = !@monthly_income ? 0 : @monthly_income.to_i
  end
  
  # Shows the statistics of users registered through the My BB form
  def mybb_signups
    @user_pages, @users = paginate :users, :per_page => 40, :conditions => "q_hear is not null", :order => "id desc"
  end
end
