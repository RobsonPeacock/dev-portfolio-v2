class CreateEducations < ActiveRecord::Migration[8.1]
  def change
    create_table :educations do |t|
      t.string :institution
      t.string :title
      t.string :field_of_study
      t.text :description
      t.date :start_date
      t.date :end_date
      t.string :certification_url

      t.timestamps
    end
  end
end
