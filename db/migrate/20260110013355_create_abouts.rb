class CreateAbouts < ActiveRecord::Migration[8.1]
  def change
    create_table :abouts do |t|
      t.string :name
      t.string :tagline
      t.text :bio
      t.string :profile_image_url
      t.string :location

      t.timestamps
    end
  end
end
