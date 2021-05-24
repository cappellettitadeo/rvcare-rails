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

ActiveRecord::Schema.define(version: 2021_05_25_011111) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"
  enable_extension "tablefunc"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "dealer_reports", force: :cascade do |t|
    t.bigint "dealer_id", null: false
    t.integer "new_units_volume", default: 0, null: false
    t.integer "new_units", default: 0
    t.integer "used_units_volume", default: 0, null: false
    t.integer "used_units", default: 0
    t.integer "service_volume", default: 0, null: false
    t.integer "parts_volume", default: 0, null: false
    t.integer "retail_finance_contracts", default: 0
    t.integer "creditor_volume", default: 0, null: false
    t.integer "warranty_volume", default: 0, null: false
    t.integer "other_volume", default: 0, null: false
    t.integer "batteries_purchases", default: 0
    t.integer "ntp_purchases", default: 0
    t.integer "dometic_purchases", default: 0
    t.integer "atlas_purchases", default: 0
    t.integer "thiebert_purchases", default: 0
    t.integer "lippert_purchases", default: 0
    t.integer "other_purchases", default: 0
    t.date "reported_on", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dealer_id"], name: "index_dealer_reports_on_dealer_id"
  end

  create_table "dealers", force: :cascade do |t|
    t.string "company"
    t.string "legal_name"
    t.string "mailing_address"
    t.string "city"
    t.string "province"
    t.string "postal_code"
    t.string "phone"
    t.string "toll_free"
    t.string "fax_number"
    t.string "email"
    t.string "location_address"
    t.string "location_city"
    t.string "location_province"
    t.string "location_postal_code"
    t.string "website"
    t.date "date_joined"
    t.boolean "shareholder"
    t.boolean "director"
    t.string "atlas_account"
    t.integer "dometic_account"
    t.integer "wells_fargo_account"
    t.integer "keystone_account"
    t.string "td_sort_order"
    t.string "sal_account"
    t.integer "mega_group_account"
    t.integer "boss_account"
    t.string "dms_system"
    t.string "crm_system"
    t.string "employee_benefits_provider"
    t.string "customs_broker"
    t.string "rv_transport"
    t.string "digital_marketing"
    t.text "rv_brands"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "ntp_account"
    t.string "td_account"
  end

  create_table "entries", force: :cascade do |t|
    t.string "type"
    t.bigint "partner_report_id", null: false
    t.bigint "dealer_id", null: false
    t.date "reported_on"
    t.integer "value", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "extra"
    t.index ["dealer_id", "partner_report_id", "reported_on", "type"], name: "unique_entry", unique: true
    t.index ["dealer_id"], name: "index_entries_on_dealer_id"
    t.index ["partner_report_id"], name: "index_entries_on_partner_report_id"
  end

  create_table "partner_reports", force: :cascade do |t|
    t.string "type", default: "BlankReport"
    t.bigint "partner_id", null: false
    t.integer "year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "parameters", default: {}
    t.integer "total_rvcare_share", default: 0
    t.integer "total_dealer_share", default: 0
    t.integer "total_units"
    t.integer "total_sales"
    t.integer "total_return_amount", default: 0
    t.index ["partner_id", "year", "type"], name: "unique_partner_report", unique: true
    t.index ["partner_id"], name: "index_partner_reports_on_partner_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "custom_dealer_id"
  end

  create_table "results", force: :cascade do |t|
    t.bigint "dealer_id", null: false
    t.bigint "partner_report_id", null: false
    t.integer "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "sales", default: 0
    t.integer "units", default: 0
    t.index ["dealer_id"], name: "index_results_on_dealer_id"
    t.index ["partner_report_id"], name: "index_results_on_partner_report_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "settings", id: :serial, force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.string "target_type", null: false
    t.integer "target_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["target_type", "target_id", "var"], name: "index_settings_on_target_type_and_target_id_and_var", unique: true
    t.index ["target_type", "target_id"], name: "index_settings_on_target"
  end

  create_table "staffs", force: :cascade do |t|
    t.bigint "dealer_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "position"
    t.string "email"
    t.integer "access_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dealer_id"], name: "index_staffs_on_dealer_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "users_widgets", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "widget_id", null: false
    t.index ["user_id", "widget_id"], name: "index_users_widgets_on_user_id_and_widget_id"
  end

  create_table "widgets", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.string "chart_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "global", default: false
    t.boolean "fullscreen", default: false
  end

  add_foreign_key "dealer_reports", "dealers"
  add_foreign_key "entries", "dealers"
  add_foreign_key "entries", "partner_reports"
  add_foreign_key "partner_reports", "partners"
  add_foreign_key "results", "dealers"
  add_foreign_key "results", "partner_reports"
  add_foreign_key "staffs", "dealers"
  add_foreign_key "taggings", "tags"

  create_view "totals_per_dealer_by_partners", sql_definition: <<-SQL
      SELECT dealers.company AS dealer,
      partners.name AS partner,
      partner_reports.type,
      partner_reports.year,
      results.units,
      results.sales,
      results.amount
     FROM (((results
       JOIN dealers ON ((dealers.id = results.dealer_id)))
       JOIN partner_reports ON ((partner_reports.id = results.partner_report_id)))
       JOIN partners ON ((partners.id = partner_reports.partner_id)));
  SQL
  create_view "partner_totals", sql_definition: <<-SQL
      SELECT partners.name,
      partner_reports.type,
      partner_reports.year,
      partner_reports.total_units,
      partner_reports.total_sales,
      partner_reports.total_return_amount,
      partner_reports.total_rvcare_share,
      partner_reports.total_dealer_share
     FROM (partner_reports
       JOIN partners ON ((partners.id = partner_reports.partner_id)));
  SQL
end
