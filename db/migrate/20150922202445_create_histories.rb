class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :userid
      t.string :bookid
      t.string :checkouttime
      t.string :returntime

      t.timestamps null: false
    end
  end
end
