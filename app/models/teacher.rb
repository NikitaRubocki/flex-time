class Teacher < ApplicationRecord

  enum title: ['Miss', 'Mr.', 'Mrs.', 'Ms.']

  validates_presence_of :name
  validates_presence_of :title
  validates :name, uniqueness: { scope: :title, case_sensitive: false }

  has_many :students, class_name: 'User'

  def to_s
    "#{title} #{name}"
  end

end
