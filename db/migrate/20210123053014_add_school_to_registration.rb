class AddSchoolToRegistration < ActiveRecord::Migration[5.2]
  def up
    add_reference :registrations, :school, foreign_key: true
    initial_default_school = School.find_or_create_by(slug: 'defaultschool') { |s| s.name = 'Default School' }
    execute <<-SQL.squish
      UPDATE registrations
      SET school_id = #{initial_default_school.id};
    SQL
    change_column_null :registrations, :school_id, true
  end

  def down
    remove_reference :registrations, :school
  end
end
