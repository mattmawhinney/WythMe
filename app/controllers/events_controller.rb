class EventsController < ApplicationController
  before_action :set_event, only: [ :edit, :update, :destroy ]
  before_action :require_logged_in, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_event_to_join, only: [:join]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    # @events = current_user.events.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @attendee_destroy = Attendee.where("user_id = ? AND event_id = 1", params[:user_id])
    
  end

  # GET /events/new
  def new
    # @event = Event.new
    @event = current_user.events.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = current_user.events.new(event_params)
    # @event = Event.new(event_params)

    
    

    respond_to do |format|
      if @event.save
        #add the creator of an event as an attendee
        @attendee = @event.attendees.create(user_id: current_user.id)
        format.html { redirect_to user_path(@event.user), notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }

      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def join 
    #define which @event
    @attendee = @event.attendees.create(user_id: current_user.id)
    redirect_to user_path(@event.user)
    



  end 


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_to_join 
      
      @event = Event.find(params[:id])

    end 

    def set_event
      @event = current_user.events.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:description, :location, :date, :time, :user_id)
      # params[:event]
    end
end
