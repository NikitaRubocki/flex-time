# Registration Tests
# The fixtures create the following activities and registrations.
# It's important to travel_to Date.today.monday, as the fixtures
# for activities have particular dates.
# See registrations, activities, teachers, and users fixtures.
#
# Activities
# ----------
# T  R  F    T  R  F    T  R  F
# a  b  c    d  f  h    i  j  k
#            e  g
#
# Registrations
# -------------
# T  R  F    T  R  F    T  R  F
# a          d  g       i
#
require 'application_system_test_case'

class RegistrationsTest < ApplicationSystemTestCase

  include Devise::Test::IntegrationHelpers

  def sign_in_as_student_and_visit_profile
    sign_in users(:student)
    visit student_path(users(:student))
  end

  # Staff registers student for activities

  test 'staff registers a student for an activity' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit student_path(users(:student))
      assert_no_selector 'h5', text: 'Fake Friday Activity'
      within '#friday' do
        select 'Fake Friday Activity', from: 'registration_activity_id'
        click_button 'Sign Up'
      end
      assert_text 'Successfully registered for Fake Friday Activity'
      assert_selector 'h5', text: 'Fake Friday Activity'
    end
  end

  test 'staff cannot register student for activities that are full' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit student_path(users(:second_student))
      within '#thursday' do
        assert has_select?('registration_activity_id')
        refute has_select?('registration_activity_id', with_options: ['Second Fake Thursday Activity'])
      end
    end
  end

  # Student registering for activities

  test 'student registers for an activity' do
    travel_to Date.today.monday do
      sign_in_as_student_and_visit_profile
      assert_no_selector 'h5', text: 'Fake Friday Activity'
      within '#friday' do
        select 'Fake Friday Activity', from: 'registration_activity_id'
        click_button 'Sign Up'
      end
      assert_text 'Successfully registered for Fake Friday Activity'
      assert_selector 'h5', text: 'Fake Friday Activity'
    end
  end

  test 'student should be able to register for activities one week in advance' do
    sign_in_as_student_and_visit_profile
    one_pm_thursday = DateTime.now.thursday.change({hour:13, min:0, sec: 0})
    travel_to one_pm_thursday do
      click_link 'Next week'
      within '#thursday' do
        select 'Fake Next Thursday Activity', from: 'registration_activity_id'
        click_button 'Sign Up'
      end
      assert_text 'Successfully registered for Fake Next Thursday Activity'
      assert_selector 'h5', text: 'Fake Next Thursday Activity'
    end
  end

  test 'student should not be able to register for activities more than one week in advance' do
    skip
  end

  test 'student cannot register for activities on past dates' do
    travel_to Date.today.monday do
      sign_in_as_student_and_visit_profile
      click_link 'Previous week'
      refute has_select?('registration_activity_id')
    end
  end

  test 'student cannot register for activities that are full' do
    travel_to Date.today.monday do
      sign_in users(:second_student)
      visit student_path(users(:second_student))
      within '#thursday' do
        assert has_select?('registration_activity_id')
        refute has_select?('registration_activity_id', with_options: ['Second Fake Thursday Activity'])
      end
    end
  end

  # Staff viewing lists of student registrations

  test 'staff can view list of all student registrations for the current week' do
    travel_to Date.today.monday do
      sign_in users(:staff)
      visit students_path
      within "#student_#{users(:student).id}" do
        within('.student') { assert_text 'Fake Student' }
        within('.teacher') { assert_text 'Miss Valid' }
        within('.tuesday') { assert_text 'Fake Tuesday Activity' }
        within('.thursday') { assert_text 'Second Fake Thursday Activity' }
        assert find('.friday').text == ''
      end
    end
  end

end
