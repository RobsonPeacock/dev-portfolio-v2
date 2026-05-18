class AddTechStackToProjects < ActiveRecord::Migration[8.1]
  def change
    add_column :projects, :tech_stack, :string, array: true, default: []
  end
end
