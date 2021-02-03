require 'application_system_test_case'

class SysAdminViewsSchoolsTest < ApplicationSystemTestCase

  include Devise::Test::IntegrationHelpers

  test 'sys_admin views list of schools' do
    school = schools(:first)
    sign_in(users(:sys_admin))
    visit sys_admin_schools_path
    assert_text school.name
  end

  test 'sys_admin views a school' do
    school = schools(:first)
    sign_in(users(:sys_admin))
    visit sys_admin_school_path(school)
    assert_text school.name
  end

  test 'sys_admin creates a new school with invalid attributes' do
    sign_in(users(:sys_admin))
    visit new_sys_admin_school_path
    click_on 'Create School'
    assert_text 'error'
  end

  test 'sys_admin creates a new school with valid attributes' do
    sign_in(users(:sys_admin))
    visit new_sys_admin_school_path
    fill_in 'Name', with: 'Fake School Name'
    fill_in 'Slug', with: 'fakeschoolslug'
    click_on 'Create School'
    assert_text 'has been created'
  end

end
