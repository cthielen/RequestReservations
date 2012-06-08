class ReservationsController < ApplicationController
  # GET /reservations
  # GET /reservations.json
  def index
    @reservations = Reservation.where(:loginid => session[:cas_user])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reservations }
    end
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reservation }
    end
  end

  # GET /reservations/new
  # GET /reservations/new.json
  def new
    @reservation = Reservation.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reservation }
    end
  end

  # GET /reservations/1/edit
  def edit
    @reservation = Reservation.find(params[:id])
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = Reservation.new(params[:reservation])

    # Fill in implied parameters
    @reservation.status = Status.find_by_label("New")
    @reservation.expiration = 180 # days
    @reservation.requested_at = Time.now
    @reservation.loginid = session[:cas_user]

    respond_to do |format|
      if @reservation.save
        ReservationMailer.new_reservation(@reservation).deliver
        format.html { redirect_to reservations_path, notice: 'Reservation was successfully created.' }
        format.json { render json: @reservation, status: :created, location: @reservation }
      else
        format.html { render action: "new" }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reservations/1
  # PUT /reservations/1.json
  def update
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      if @reservation.update_attributes(params[:reservation])
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to reservations_url }
      format.json { head :no_content }
    end
  end
  
  def approve
    @reservation = Reservation.find(params[:reservation_id])
    @reservation.status = Status.find_by_label('Approved')
    @reservation.save

    respond_to do |format|
      format.html { redirect_to @reservation, notice: 'Reservation was approved.' }
      format.json { render json: @reservation }
    end
  end
  
  def deny
    @reservation = Reservation.find(params[:reservation_id])
    @reservation.status = Status.find_by_label('Denied')
    @reservation.save

    respond_to do |format|
      format.html { redirect_to @reservation, notice: 'Reservation was denied.' }
      format.json { render json: @reservation }
    end
  end
end
