# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20131117073353) do

  create_table "roles", force: true do |t|
    t.string  "name"
    t.boolean "global", default: false, null: false
  end

  create_table "sale_items", force: true do |t|
    t.integer "sale_receipt_id"
    t.integer "product_id"
    t.string  "product_name"
    t.integer "quantity"
    t.decimal "price",           precision: 10, scale: 2
    t.decimal "value",           precision: 10, scale: 2
    t.decimal "net_value",       precision: 10, scale: 2
    t.string  "vat_symbol"
    t.decimal "vat_rate",        precision: 2,  scale: 2
    t.integer "line_number"
  end

  add_index "sale_items", ["product_id"], name: "index_sale_items_on_product_id", using: :btree
  add_index "sale_items", ["sale_receipt_id"], name: "index_sale_items_on_sale_receipt_id", using: :btree

  create_table "sale_receipts", force: true do |t|
    t.integer  "sale_id"
    t.integer  "number"
    t.datetime "datetime"
    t.decimal  "value",          precision: 10, scale: 2
    t.decimal  "net_value",      precision: 10, scale: 2
    t.boolean  "cancelled",                               default: false
    t.integer  "salesman_id"
    t.integer  "begins_at_line"
    t.integer  "ends_at_line"
  end

  add_index "sale_receipts", ["sale_id"], name: "index_sale_receipts_on_sale_id", using: :btree

  create_table "sales", force: true do |t|
    t.integer  "company_id"
    t.integer  "pos_id"
    t.date     "date"
    t.integer  "number"
    t.decimal  "value",                                    precision: 10, scale: 2
    t.decimal  "vat",                                      precision: 10, scale: 2
    t.decimal  "card_payments",                            precision: 10, scale: 2
    t.decimal  "cash_payments",                            precision: 10, scale: 2
    t.integer  "receipt_count"
    t.integer  "cancelled_receipt_count"
    t.decimal  "cancelled_receipt_value",                  precision: 10, scale: 2
    t.binary   "file_content",            limit: 16777215
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stores", force: true do |t|
    t.string "symbol"
    t.string "name"
  end

  create_table "stores_users", force: true do |t|
    t.integer "store_id"
    t.integer "user_id"
  end

  create_table "user_roles", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "role_id",    null: false
    t.integer  "store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "current_store_id"
    t.boolean  "active",                 default: false, null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "vat_rates", force: true do |t|
    t.string  "symbol", limit: 1
    t.decimal "rate",             precision: 3, scale: 2
  end

end
