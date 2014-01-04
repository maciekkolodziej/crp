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

ActiveRecord::Schema.define(version: 20140103134037) do

  create_table "database_resets", force: true do |t|
    t.string   "ip"
    t.string   "hostname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_aliases", force: true do |t|
    t.integer "product_id"
    t.string  "alias",      limit: 18
  end

  add_index "product_aliases", ["product_id"], name: "product_aliases_product_id_fk", using: :btree

  create_table "product_categories", force: true do |t|
    t.integer "symbol"
    t.string  "name",   limit: 45
  end

  create_table "product_prices", force: true do |t|
    t.integer  "store_id",                            null: false
    t.integer  "product_id",                          null: false
    t.decimal  "sale_price", precision: 10, scale: 2, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "product_prices", ["product_id"], name: "product_prices_product_id_fk", using: :btree
  add_index "product_prices", ["store_id", "product_id"], name: "index_product_prices_on_store_id_and_product_id", unique: true, using: :btree

  create_table "products", force: true do |t|
    t.string   "name",          limit: 45,                                          null: false
    t.integer  "unit_id",                                           default: 1,     null: false
    t.boolean  "active",                                            default: true,  null: false
    t.boolean  "purchasable",                                       default: false, null: false
    t.boolean  "inventoried",                                       default: false, null: false
    t.decimal  "cost_price",               precision: 10, scale: 2
    t.boolean  "sellable",                                          default: false, null: false
    t.integer  "register_code"
    t.string   "register_name", limit: 18
    t.integer  "category_id"
    t.integer  "vat_rate_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.integer  "updater_id"
  end

  add_index "products", ["active"], name: "index_products_on_active", using: :btree
  add_index "products", ["category_id"], name: "products_category_id_fk", using: :btree
  add_index "products", ["register_code"], name: "index_products_on_register_code", using: :btree
  add_index "products", ["register_name"], name: "index_products_on_register_name", using: :btree
  add_index "products", ["unit_id"], name: "products_unit_id_fk", using: :btree
  add_index "products", ["vat_rate_id"], name: "products_vat_rate_id_fk", using: :btree

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
    t.integer  "store_id"
    t.date     "date"
    t.integer  "number"
    t.decimal  "value",                    precision: 10, scale: 2
    t.decimal  "vat",                      precision: 10, scale: 2
    t.integer  "receipts_count"
    t.integer  "cancelled_receipts_count"
    t.decimal  "cancelled_receipts_value", precision: 10, scale: 2
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "file_fingerprint"
    t.integer  "report_line"
  end

  add_index "sales", ["store_id"], name: "sales_store_id_fk", using: :btree

  create_table "stores", force: true do |t|
    t.string  "symbol"
    t.string  "name"
    t.string  "register_header"
    t.boolean "active",          default: true, null: false
  end

  create_table "stores_users", force: true do |t|
    t.integer "store_id"
    t.integer "user_id"
  end

  create_table "takings", force: true do |t|
    t.integer  "store_id",                               default: 0, null: false
    t.date     "date",                                               null: false
    t.decimal  "value",         precision: 10, scale: 2,             null: false
    t.decimal  "card_payments", precision: 10, scale: 2,             null: false
    t.decimal  "cash_payments", precision: 10, scale: 2
    t.integer  "creator_id"
    t.integer  "updater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "takings", ["store_id"], name: "takings_store_id_fk", using: :btree

  create_table "units", force: true do |t|
    t.string  "symbol",  limit: 7,                  null: false
    t.string  "name",    limit: 45
    t.boolean "primary",            default: false, null: false
  end

  add_index "units", ["symbol"], name: "index_units_on_symbol", using: :btree

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

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "product_aliases", "products", name: "product_aliases_product_id_fk", dependent: :delete

  add_foreign_key "product_prices", "products", name: "product_prices_product_id_fk", dependent: :delete
  add_foreign_key "product_prices", "stores", name: "product_prices_store_id_fk", dependent: :delete

  add_foreign_key "products", "product_categories", name: "products_category_id_fk", column: "category_id", dependent: :nullify
  add_foreign_key "products", "units", name: "products_unit_id_fk"
  add_foreign_key "products", "vat_rates", name: "products_vat_rate_id_fk"

  add_foreign_key "sale_items", "products", name: "sale_items_product_id_fk", dependent: :nullify

  add_foreign_key "sales", "stores", name: "sales_store_id_fk"

  add_foreign_key "takings", "stores", name: "takings_store_id_fk"

end
