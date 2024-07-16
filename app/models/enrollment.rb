class Enrollment < ApplicationRecord
  belongs_to :user, foreign_key: :user_id
  belongs_to :student, foreign_key: :user_id, class_name: 'User'
  belongs_to :teacher, foreign_key: :teacher_id, class_name: 'User'
  belongs_to :program

  validates :user_id, presence: true
  validates :teacher_id, presence: true
  validates :program_id, presence: true

  scope :favorites, -> { where(favorite: true) }
end
