class WorkExperience < ApplicationRecord
  belongs_to :about

  validates :company, :description, :role, 
            :start_date, presence: true
  validates :end_date, presence: true, comparison: { greater_than: :start_date }
end
