class About < ApplicationRecord
  has_many :work_experiences, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :projects, dependent: :destroy
end
