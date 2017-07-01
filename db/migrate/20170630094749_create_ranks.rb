class CreateRanks < ActiveRecord::Migration[5.1]
  def change
    create_table :ranks do |t|
      t.integer :score
      t.references :ballot, foreign_key: true
      t.references :option, foreign_key: true

      t.timestamps
    end
  end
end
