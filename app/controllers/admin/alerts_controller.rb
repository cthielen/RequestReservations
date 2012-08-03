class Admin::AlertsController < Admin::BaseController
  filter_access_to :all

  # GET /alerts
  # GET /alerts.json
  def index
    # This action renders a modal dialog which serves both the index & new functions,
    # hence both variables being created here.
    @alerts = Alert.all
    @alert = Alert.new

    respond_to do |format|
      format.html { render :partial => "index", :layout => false }
      format.json { render json: @alerts }
    end
  end

  # GET /alerts/1.json
  def show
    @alert = Alert.find(params[:id])

    respond_to do |format|
      format.json { render json: @alert }
    end
  end

  # GET /alerts/new.json
  def new
    @alert = Alert.new

    respond_to do |format|
      format.json { render json: @alert }
    end
  end

  # GET /alerts/1/edit
  def edit
    @alert = Alert.find(params[:id])
  end

  # POST /alerts.json
  def create
    @alert = Alert.new(params[:alert])

    respond_to do |format|
      if @alert.save
        format.json { render json: @alert, status: :created, location: admin_alert_path(@alert) }
      else
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /alerts/1.json
  def update
    @alert = Alert.find(params[:id])

    respond_to do |format|
      if @alert.update_attributes(params[:alert])
        format.json { head :no_content }
      else
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alerts/1.json
  def destroy
    @alert = Alert.find(params[:id])
    @alert.destroy

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
