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

ActiveRecord::Schema.define(version: 2019_03_27_133415) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audio_files", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "codec_id", null: false
    t.string "filename", null: false
    t.integer "length", null: false
    t.integer "bitrate", null: false
    t.index ["codec_id"], name: "index_audio_files_on_codec_id"
    t.index ["location_id", "filename"], name: "index_audio_files_on_location_id_and_filename", unique: true
    t.index ["location_id"], name: "index_audio_files_on_location_id"
  end

  create_table "auth_tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "device_id", null: false
    t.string "hashed_secret", null: false
    t.string "user_agent", null: false
    t.index ["device_id"], name: "index_auth_tokens_on_device_id", unique: true
    t.index ["user_id"], name: "index_auth_tokens_on_user_id"
  end

  create_table "codec_conversions", force: :cascade do |t|
    t.string "name", null: false
    t.string "ffmpeg_params", null: false
    t.bigint "resulting_codec_id", null: false
    t.index ["name"], name: "index_codec_conversions_on_name", unique: true
    t.index ["resulting_codec_id"], name: "index_codec_conversions_on_resulting_codec_id"
  end

  create_table "codecs", force: :cascade do |t|
    t.string "mimetype", null: false
    t.string "extension", null: false
    t.index ["extension"], name: "index_codecs_on_extension", unique: true
  end

  create_table "cover_filenames", force: :cascade do |t|
    t.string "filename", null: false
    t.index ["filename"], name: "index_cover_filenames_on_filename", unique: true
  end

  create_table "image_types", force: :cascade do |t|
    t.string "extension", null: false
    t.string "mimetype", null: false
    t.index ["extension"], name: "index_image_types_on_extension", unique: true
  end

  create_table "locations", force: :cascade do |t|
    t.string "path", null: false
    t.index ["path"], name: "index_locations_on_path", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "permission", default: 0, null: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "audio_files", "codecs"
  add_foreign_key "audio_files", "locations"
  add_foreign_key "auth_tokens", "users"
  add_foreign_key "codec_conversions", "codecs", column: "resulting_codec_id"
end
