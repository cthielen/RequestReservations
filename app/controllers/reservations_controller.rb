class ReservationsController < ApplicationController
  filter_access_to :all

  # GET /reservations
  # GET /reservations.json
  def index
    if current_user.has_role? :admin
      @reservations = Reservation.all
    else
      @reservations = Reservation.where(:loginid => session[:cas_user])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reservations }
    end
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    @reservation = Reservation.find(params[:id])
    @reservation_days = (Date.today - @reservation.requested_at).to_f

    if(current_user.loginid != @reservation.loginid) && (current_user.has_role? :admin == false)
      @reservation = nil
    end

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

    if(current_user.loginid != @reservation.loginid) && (current_user.has_role? :admin == false)
      @reservation = nil
    end
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
        # Generate a mail
        ReservationMailer.new_reservation(@reservation).deliver

        if SYSAID_SUPPORT
          # Generate a ticket
          ticket = SysAid::Ticket.new
          ticket.title = "New #{@reservation.reservation_type_in_words} request from #{@reservation.loginid}"
          ticket.assignedTo = "cthielen"
          ticket.requestUser = @reservation.loginid
          ticket.status = SYSAID_STATUS_NEW
          ticket.save
          logger.info "Generated a SysAid ticket with ID #{ticket.id} for reservation no. #{@reservation.id}"
          @reservation.sysaid_id = ticket.id
          @reservation.save # we'll assume this works since it just did and we're only changing an optional parameter
        end

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
      if(current_user.loginid == @reservation.loginid) || (current_user.has_role? :admin)
        if @reservation.update_attributes(params[:reservation])
          format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @reservation.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to reservations_path, notice: 'You do not have permission to edit that reservation.' }
        format.json { render json: nil, status: :failed, location: reservations_path }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  # Note: We never delete a reservation. We merely change its status to cancelled.
  def destroy
    @reservation = Reservation.find(params[:id])

    if(current_user.loginid == @reservation.loginid) || (current_user.has_role? :admin)
      @reservation.status = Status.find_by_label("Cancelled")
      @reservation.save

      if SYSAID_SUPPORT
        # Ensure the corresponding SysAid ticket is updated
        ticket = SysAid.find_by_id(@reservation.sysaid_id)
        ticket.status = SYSAID_STATUS_CLOSED
        ticket.notes = "Closed by Request Reservations system (cancelled)"
        ticket.save
      end
    end

    respond_to do |format|
      format.html { redirect_to reservations_url }
      format.json { head :no_content }
    end
  end

  def approve
    @reservation = Reservation.find(params[:reservation_id])
    @reservation.status = Status.find_by_label('Approved')
    @reservation.save

    if SYSAID_SUPPORT
      # Ensure the corresponding SysAid ticket is updated
      ticket = SysAid.find_by_id(@reservation.sysaid_id)
      ticket.status = SYSAID_STATUS_CLOSED
      ticket.notes = "Closed by Request Reservations system (approved)"
      ticket.save
    end

    respond_to do |format|
      format.html { redirect_to @reservation, notice: 'Reservation was approved.' }
      format.json { render json: @reservation }
    end
  end

  def deny
    @reservation = Reservation.find(params[:reservation_id])
    @reservation.status = Status.find_by_label('Denied')
    @reservation.save

    if SYSAID_SUPPORT
      # Ensure the corresponding SysAid ticket is updated
      ticket = SysAid.find_by_id(@reservation.sysaid_id)
      ticket.status = SYSAID_STATUS_CLOSED
      ticket.notes = "Closed by Request Reservations system (denied)"
      ticket.save
    end

    respond_to do |format|
      format.html { redirect_to @reservation, notice: 'Reservation was denied.' }
      format.json { render json: @reservation }
    end
  end
end
