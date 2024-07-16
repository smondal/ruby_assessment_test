class Program < ApplicationRecord
  has_many :enrollments
  has_many :students, through: :enrollments, source: :user
  has_many :teachers, through: :enrollments, source: :teacher
end
