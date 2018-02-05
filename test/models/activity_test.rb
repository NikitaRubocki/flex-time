require 'test_helper'

class ActivityTest < ActiveSupport::TestCase

  def activity
    activities(:tuesday_activity)
  end

  test 'without a name is invalid' do
    assert activity.valid?
    activity.name = nil
    assert activity.invalid?
  end

  test 'without a room is invalid' do
    assert activity.valid?
    activity.room = nil
    assert activity.invalid?
  end

  test 'without a capacity is invalid' do
    assert activity.valid?
    activity.capacity = nil
    assert activity.invalid?
  end

  test 'capacity is an integer greater than or equal to 0' do
    assert activity.valid?
    activity.capacity = -1
    assert activity.invalid?
    activity.capacity = 2.3
    assert activity.invalid?
  end

  test 'without a date is invalid' do
    assert activity.valid?
    activity.date = nil
    assert activity.invalid?
  end

  test 'without a date on Tuesday, Thursday or Friday is invalid' do
    assert activity.valid?
    activity.date = activity.date.monday
    assert activity.invalid?
  end

  test 'has a unique name, room and date' do
    existing_activity = activity
    activity = Activity.new(name: existing_activity.name, room: existing_activity.room, date: existing_activity.date)
    assert_raises { activity.save! }
  end

  test 'has registrations' do
    assert_respond_to activities(:tuesday_activity), :registrations
    assert_kind_of Registration, activities(:tuesday_activity).registrations.first
  end

  test 'string representation includes name, room and date' do
    assert_equal activity.to_s, "Fake Tuesday Activity (Fake Room) on #{activity.date.strftime("%A, %b %-e %Y")}"
  end

  test 'previous string representation includes name, room and date before modification' do
    a = activity
    assert_equal a.to_s, "Fake Tuesday Activity (Fake Room) on #{a.date.strftime("%A, %b %-e %Y")}"
    a.name = 'FAKE'
    assert_equal a.to_s, "FAKE (Fake Room) on #{a.date.strftime("%A, %b %-e %Y")}"
    assert_equal a.to_s_was, "Fake Tuesday Activity (Fake Room) on #{a.date.strftime("%A, %b %-e %Y")}"
  end

  # full?

  test 'is full when the number of registrations equal capacity' do
    assert activity.full?
  end

  test 'is not full when the number of registrations does not exceed capacity' do
    refute activities(:friday_activity).full?
  end

end
