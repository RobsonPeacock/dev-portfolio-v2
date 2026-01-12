class Project < ApplicationRecord
  belongs_to :about

  validates :description, :status, :title, presence: true
end
