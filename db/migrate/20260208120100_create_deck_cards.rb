class CreateDeckCards < ActiveRecord::Migration[8.0]
  def change
    create_table :deck_cards do |t|
      t.references :deck, null: false, foreign_key: true
      t.string :original_name, null: false
      t.integer :quantity, null: false
      t.string :card_type
      t.string :themed_name, null: false
      t.text :art_description, null: false
      t.string :image_url

      t.timestamps
    end

    add_index :deck_cards, [:deck_id, :original_name], unique: true
  end
end
