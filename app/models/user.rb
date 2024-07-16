class User < ApplicationRecord
    enum kind: { student: 0, teacher: 1, student_teacher: 2 }

    has_many :student_enrollments, class_name: 'Enrollment', foreign_key: :user_id
    has_many :teacher_enrollments, class_name: 'Enrollment', foreign_key: :teacher_id
  
    has_many :students, through: :teacher_enrollments, source: :user
    has_many :teachers, through: :student_enrollments, source: :teacher
    before_update :role_check?

    def favorite_teachers
        User.joins(:teacher_enrollments).where(enrollments: { user_id: id, favorite: true }).distinct
    end

    def self.classmates(user)
        program_ids = user.student_enrollments.pluck(:program_id)
        User.joins(:student_enrollments)
            .where(enrollments: { program_id: program_ids })
            .where.not(id: user.id)
            .distinct
    end

    def role_check?
      if self.kind_changed? && (student_enrollments.exists? || teacher_enrollments.exists?) && (self.kind == "teacher" || self.kind == "student")
        errors.add(:base, "Kind can not be #{self.kind} because is teaching in at least one program") if self.kind == "student" 
        errors.add(:base, "Kind can not be #{self.kind} because is studying in at least one program") if self.kind == "teacher" 
        throw :abort
      end
    end
    
end
