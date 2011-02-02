class PlansController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @plans = Plan.find(:all, :order => 'price, name');
    @features = Feature.find(:all, :order => 'name');
    
# this select statement does not work on mysql 5
#    pf = Plan.connection().select_all('select p.id pid, f.id fid, coalesce(pf.value, default_value) value from plans p, features f left join plans_features pf on p.id=pf.plan_id and f.id=pf.feature_id')
    pf = Plan.connection().select_all('select p.id pid, f.id fid, coalesce(pf.value, default_value) value from plans p join features f left join plans_features pf on p.id=pf.plan_id and f.id=pf.feature_id')
    @plan_features = []
    pf.each do |r|
      pid = r['pid'].to_i
      fid = r['fid'].to_i
      val = r['value']

      f = @plan_features[pid]
      f = [] if !f
      f[fid] = val
      @plan_features[pid] = f
    end
  end

  def show
    @plan = Plan.find(params[:id])
    @features = @plan.all_features
  end

  def new
    @plan = Plan.new
    @features = Feature.find_all
  end

  def create
    @plan = Plan.new(params[:plan])
    if @plan.save
      flash[:notice] = 'Plan was successfully created.'

      # Save features
      save_features(@plan, params[:features])

      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @plan = Plan.find(params[:id])
    @features = @plan.overriden_features
  end

  def update
    @plan = Plan.find(params[:id])
    @plan.serial = @plan.serial + 1
    if @plan.update_attributes(params[:plan])
      flash[:notice] = 'Plan was successfully updated.'

      # Save features
      save_features(@plan, params[:features])

      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    Plan.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def save_features(plan, features)
    Plan.transaction do
      plan.clear_features
    
      features.each do |key, val|
        if val != ""
          id = key.split('_')[1].to_i
          plan.add_feature(id, val)
        end
      end
    end
  end
end
