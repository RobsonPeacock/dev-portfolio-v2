class CreateWorkExperiences < ActiveRecord::Migration[8.1]
  def change
    create_table :work_experiences do |t|
      t.string :company
      t.string :role
      t.text :description
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
