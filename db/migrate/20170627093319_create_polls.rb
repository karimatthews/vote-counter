class CreatePolls < ActiveRecord::Migration[5.1]
  def change
    create_table :polls do |t|
      t.string :title
      t.string :voting_method
      t.boolean :blind

      t.timestamps
    end
  end
end
