class Admin::CommunicationsController < Admin::BaseController
  filter_access_to :all

  # GET /communications
  # GET /communications.json
  def index
    # This action renders a modal dialog which serves both the index & new functions,
    # hence both variables being created here.
    @communications = Communication.all
    @communication = Communication.new

    respond_to do |format|
      format.html { render :partial => "index", :layout => false }
      format.json { render json: @communications }
    end
  end

  # GET /communications/1.json
  def show
    @communication = Communication.find(params[:id])

    respond_to do |format|
      format.json { render json: @communication }
    end
  end

  # GET /communications/new.json
  def new
    @communication = Communication.new

    respond_to do |format|
      format.json { render json: @communication }
    end
  end

  # GET /communications/1/edit
  def edit
    @communication = Communication.find(params[:id])
  end

  # POST /communications.json
  def create
    @communication = Communication.new(params[:communication])

    respond_to do |format|
      if @communication.save
        format.json { render json: @communication, status: :created, location: admin_communication_path(@communication) }
      else
        format.json { render json: @communication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /communications/1.json
  def update
    @communication = Communication.find(params[:id])

    respond_to do |format|
      if @communication.update_attributes(params[:communication])
        format.json { head :no_content }
      else
        format.json { render json: @communication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /communications/1.json
  def destroy
    @communication = Communication.find(params[:id])
    @communication.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
