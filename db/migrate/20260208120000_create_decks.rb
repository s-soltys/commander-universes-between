class CreateDecks < ActiveRecord::Migration[8.0]
  def change
    create_table :decks do |t|
      t.string :title
      t.string :commander_name, null: false
      t.text :theme_description, null: false
      t.text :input_text, null: false
      t.string :share_slug, null: false
      t.string :status, null: false, default: "pending"

      t.timestamps
    end

    add_index :decks, :share_slug, unique: true
    add_index :decks, :status
  end
end
