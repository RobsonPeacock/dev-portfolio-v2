class AddAboutToWorkExperience < ActiveRecord::Migration[8.1]
  def change
    add_reference :work_experiences, :about, null: false, foreign_key: true
  end
end
