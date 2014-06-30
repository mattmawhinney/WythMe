class Event < ActiveRecord::Base
  belongs_to :user
  has_many :attendees
  has_many :users, through: :attendees

  validates_presence_of :description, :neighborhood, :zip_code, :street_address
  validates_length_of   :description, :maximum => 100


    # class method for sorting all events by time 
  def self.order_by_time

    order(datetime: :asc)

  end 

  # def event_attendee_image
  #   ids = self.attendees.map {|attendee| attendee.user_id}
  #   users = User.find(ids)
    


  # end 



  def has_not_passed? 

    self.datetime.utc > Time.now.utc

  end 


  #  def get_first_attendee

  #   self.attendees.first.user_id

  # end 


  def user_is_event_organizer?(current_user)

    #the organizer's attendee object will always be the first attendee object for a given event?
    self.attendees.first.user_id == current_user.id

  end 

  def user_is_event_attendee?(current_user)

    #returns true if current user is attending the event and false if not 

    !(self.attendees.find_by user_id: current_user.id).nil?
    

  end

  def date 
    self.datetime.strftime("%A, %B %d")
  end 

  def time 
    self.datetime.strftime("%I")
  end 

end
