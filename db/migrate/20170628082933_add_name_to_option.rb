class AddNameToOption < ActiveRecord::Migration[5.1]
  def change
    add_column :options, :name, :string
  end
end
