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

ActiveRecord::Schema.define(version: 20131019065245) do

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
    t.integer  "item_count"
    t.boolean  "cancelled"
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

end
