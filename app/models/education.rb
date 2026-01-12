class Education < ApplicationRecord
  belongs_to :about

  validates :description, :field_of_study, 
            :institution, :start_date, :title, presence: true
  validates :end_date, presence: true, comparison: { greater_than: :start_date }

  IMAGE_URL_FORMAT = /\Ahttps?:\/\/[\S]+\z/

  validates :certification_url,
            format: { with: IMAGE_URL_FORMAT, message: "must be a valid image URL (jpg, png, etc.)" },
            allow_blank: true
end
