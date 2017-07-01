class AddNameToBallot < ActiveRecord::Migration[5.1]
  def change
    add_column :ballots, :name, :string
  end
end
