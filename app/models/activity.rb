class Activity < ApplicationRecord

  validates_presence_of :name
  validates_presence_of :room
  validates :capacity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates_presence_of :date
  validate :date_must_be_monday_tuesday_friday, unless: Proc.new { date.nil? }
  validates_uniqueness_of :room, scope: [:date, :name], case_sensitive: false

  has_many :registrations, dependent: :destroy

  def self.for_week(date)
    {
      date.monday => Activity.where(date: date.monday).order('name').to_a,
      date.tuesday => Activity.where(date: date.tuesday).order('name').to_a,
      date.friday => Activity.where(date: date.friday).order('name').to_a
    }
  end

  def self.copy!(from_date, to_date)
    Activity.where(date: from_date).each do |a|
      Activity.create!(name: a.name, room: a.room, capacity: a.capacity, date: to_date)
    end
  end

  def self.find_with_registration_student_and_teacher(id)
    includes(registrations: [:student, :teacher]).order('users.last_name').find(id)
  end

  def full?
    registrations.size >= capacity
  end

  def week_date
    date&.monday
  end

  def day_and_room
    "#{I18n.l(date, format: :without_year)} in #{room}"
  end

  def to_s
    "#{name} (#{room}) on #{I18n.l date, format: :complete}"
  end

  def to_s_was
    "#{name_was} (#{room_was}) on #{I18n.l date_was, format: :complete}"
  end

  private

    def date_must_be_monday_tuesday_friday
      errors.add(:date, 'Must be a Monday, Tuesday or Friday') unless ['Monday', 'Tuesday', 'Friday'].include? date.day_name
    end

end
