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

ActiveRecord::Schema[7.1].define(version: 2024_07_23_210447) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_details", force: :cascade do |t|
    t.string "name"
    t.string "address1"
    t.string "address2"
    t.string "address3"
    t.string "website"
    t.string "telephone_number"
    t.string "tin_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_infos", force: :cascade do |t|
    t.string "company_name"
    t.string "website"
    t.string "physical_address"
    t.string "address"
    t.string "postal_box"
    t.integer "telephone"
    t.integer "Tin_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "damaged_goods", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.decimal "quantity", precision: 10, scale: 2
    t.text "damage_reason"
    t.datetime "damaged_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_damaged_goods_on_product_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "code"
    t.string "department_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "goods_receiveds", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "company_info_id", null: false
    t.decimal "quantity", precision: 10, scale: 2
    t.datetime "received_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_info_id"], name: "index_goods_receiveds_on_company_info_id"
    t.index ["product_id"], name: "index_goods_receiveds_on_product_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_detail_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_detail_id"], name: "index_order_items_on_product_detail_id"
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outlet_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "outlets", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "outlet_type_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["outlet_type_id"], name: "index_outlets_on_outlet_type_id"
    t.index ["product_id"], name: "index_outlets_on_product_id"
  end

  create_table "product_details", force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_product_details_on_category_id"
  end

  create_table "product_units", force: :cascade do |t|
    t.string "code"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "product_name"
    t.decimal "price"
    t.decimal "quantity", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "product_unit_id"
    t.bigint "company_info_id"
    t.bigint "department_id"
    t.index ["company_info_id"], name: "index_products_on_company_info_id"
    t.index ["department_id"], name: "index_products_on_department_id"
    t.index ["product_unit_id"], name: "index_products_on_product_unit_id"
  end

  create_table "restocks", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price", precision: 10, scale: 2
    t.index ["product_id"], name: "index_restocks_on_product_id"
  end

  add_foreign_key "damaged_goods", "products"
  add_foreign_key "goods_receiveds", "company_infos"
  add_foreign_key "goods_receiveds", "products"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "product_details"
  add_foreign_key "outlets", "outlet_types"
  add_foreign_key "outlets", "products"
  add_foreign_key "product_details", "categories"
  add_foreign_key "products", "company_infos"
  add_foreign_key "products", "departments"
  add_foreign_key "products", "product_units"
  add_foreign_key "restocks", "products"
end
