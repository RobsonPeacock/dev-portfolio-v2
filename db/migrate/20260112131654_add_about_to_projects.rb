class AddAboutToProjects < ActiveRecord::Migration[8.1]
  def change
    add_reference :projects, :about, null: false, foreign_key: true
  end
end
