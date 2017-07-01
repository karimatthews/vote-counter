class CreateBallots < ActiveRecord::Migration[5.1]
  def change
    create_table :ballots do |t|
      t.references :poll, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
