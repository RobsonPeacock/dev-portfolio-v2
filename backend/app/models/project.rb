class Project < ApplicationRecord
  belongs_to :about

  validates :description, :status, :title, :tech_stack, presence: true
end
