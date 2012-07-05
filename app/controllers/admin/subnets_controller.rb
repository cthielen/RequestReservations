class Admin::SubnetsController < Admin::BaseController
  filter_access_to :all

  # GET /subnets
  # GET /subnets.json
  def index
    # This action renders a modal dialog which serves both the index & new functions,
    # hence both variables being created here.
    @subnets = Subnet.all
    @subnet = Subnet.new

    respond_to do |format|
      format.html { render :partial => "index", :layout => false }
      format.json { render json: @subnets }
    end
  end

  # GET /subnets/1.json
  def show
    @subnet = Subnet.find(params[:id])

    respond_to do |format|
      format.json { render json: @subnet }
    end
  end

  # GET /subnets/new.json
  def new
    @subnet = Subnet.new

    respond_to do |format|
      format.json { render json: @subnet }
    end
  end

  # GET /subnets/1/edit
  def edit
    @subnet = Subnet.find(params[:id])
  end

  # POST /subnets.json
  def create
    @subnet = Subnet.new(params[:subnet])

    respond_to do |format|
      if @subnet.save
        format.json { render json: @subnet, status: :created, location: admin_subnet_path(@subnet) }
      else
        format.json { render json: @subnet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /subnets/1.json
  def update
    @subnet = Subnet.find(params[:id])

    respond_to do |format|
      if @subnet.update_attributes(params[:Subnet])
        format.json { head :no_content }
      else
        format.json { render json: @subnet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subnets/1.json
  def destroy
    @subnet = Subnet.find(params[:id])
    @subnet.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
