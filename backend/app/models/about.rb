class About < ApplicationRecord
  has_many :work_experiences, dependent: :destroy
  has_many :educations, dependent: :destroy
  has_many :projects, dependent: :destroy

  validates :bio, :location, :name, :tagline, presence: true

  IMAGE_URL_FORMAT = /\Ahttps?:\/\/[\S]+\z/

  validates :profile_image_url, 
            format: { with: IMAGE_URL_FORMAT, message: "must be a valid image URL (jpg, png, etc.)" },
            allow_blank: true
end
