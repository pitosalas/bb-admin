class FeaturesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @feature_pages, @features = paginate :features, :per_page => 10
  end

  def show
    @feature = Feature.find(params[:id])
  end

  def new
    @feature = Feature.new
  end

  def create
    @feature = Feature.new(params[:feature])
    if @feature.save
      flash[:notice] = 'Feature was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @feature = Feature.find(params[:id])
  end

  def update
    @feature = Feature.find(params[:id])
    if @feature.update_attributes(params[:feature])
      # Update all plans' serial
      Plan.find_all.each do |p|
        p.serial = p.serial + 1
        p.save
      end
      flash[:notice] = 'Feature was successfully updated.'
      redirect_to :action => 'show', :id => @feature
    else
      render :action => 'edit'
    end
  end

  def destroy
    Feature.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
