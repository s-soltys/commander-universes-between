class CreateDeckErrors < ActiveRecord::Migration[8.0]
  def change
    create_table :deck_errors do |t|
      t.references :deck, null: false, foreign_key: true
      t.integer :line_number, null: false
      t.text :line_text, null: false
      t.string :error_code, null: false
      t.text :message, null: false

      t.timestamps
    end

    add_index :deck_errors, :error_code
  end
end
