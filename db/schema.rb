# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2026_02_08_120200) do
  create_table "deck_cards", force: :cascade do |t|
    t.integer "deck_id", null: false
    t.string "original_name", null: false
    t.integer "quantity", null: false
    t.string "card_type"
    t.string "themed_name", null: false
    t.text "art_description", null: false
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id", "original_name"], name: "index_deck_cards_on_deck_id_and_original_name", unique: true
    t.index ["deck_id"], name: "index_deck_cards_on_deck_id"
  end

  create_table "deck_errors", force: :cascade do |t|
    t.integer "deck_id", null: false
    t.integer "line_number", null: false
    t.text "line_text", null: false
    t.string "error_code", null: false
    t.text "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deck_id"], name: "index_deck_errors_on_deck_id"
    t.index ["error_code"], name: "index_deck_errors_on_error_code"
  end

  create_table "decks", force: :cascade do |t|
    t.string "title"
    t.string "commander_name", null: false
    t.text "theme_description", null: false
    t.text "input_text", null: false
    t.string "share_slug", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["share_slug"], name: "index_decks_on_share_slug", unique: true
    t.index ["status"], name: "index_decks_on_status"
  end

  add_foreign_key "deck_cards", "decks"
  add_foreign_key "deck_errors", "decks"
end
