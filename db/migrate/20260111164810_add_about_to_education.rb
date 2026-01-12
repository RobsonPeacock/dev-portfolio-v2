class AddAboutToEducation < ActiveRecord::Migration[8.1]
  def change
    add_reference :educations, :about, null: false, foreign_key: true
  end
end
