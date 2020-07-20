# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_20_092916) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "album_artists", force: :cascade do |t|
    t.bigint "album_id", null: false
    t.bigint "artist_id", null: false
    t.string "name", null: false
    t.integer "order", null: false
    t.string "separator"
    t.string "normalized_name", null: false
    t.index ["album_id", "artist_id", "name"], name: "index_album_artists_on_album_id_and_artist_id_and_name", unique: true
    t.index ["album_id"], name: "index_album_artists_on_album_id"
    t.index ["artist_id"], name: "index_album_artists_on_artist_id"
    t.index ["normalized_name"], name: "index_album_artists_on_normalized_name"
  end

  create_table "album_labels", force: :cascade do |t|
    t.bigint "album_id", null: false
    t.bigint "label_id", null: false
    t.string "catalogue_number"
    t.index ["album_id", "label_id"], name: "index_album_labels_on_album_id_and_label_id", unique: true
    t.index ["album_id"], name: "index_album_labels_on_album_id"
    t.index ["label_id"], name: "index_album_labels_on_label_id"
  end

  create_table "albums", force: :cascade do |t|
    t.string "title", null: false
    t.bigint "image_id"
    t.date "release"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "review_comment"
    t.date "edition"
    t.string "edition_description"
    t.string "normalized_title", null: false
    t.index ["image_id"], name: "index_albums_on_image_id", unique: true
    t.index ["normalized_title"], name: "index_albums_on_normalized_title"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "image_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "review_comment"
    t.string "normalized_name", null: false
    t.index ["image_id"], name: "index_artists_on_image_id", unique: true
    t.index ["normalized_name"], name: "index_artists_on_normalized_name"
  end

  create_table "audio_files", force: :cascade do |t|
    t.bigint "location_id", null: false
    t.bigint "codec_id", null: false
    t.string "filename", null: false
    t.integer "length", null: false
    t.integer "bitrate", null: false
    t.integer "sample_rate", null: false
    t.integer "bit_depth", null: false
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

  create_table "content_lengths", force: :cascade do |t|
    t.bigint "audio_file_id", null: false
    t.bigint "codec_conversion_id", null: false
    t.integer "length", null: false
    t.index ["audio_file_id", "codec_conversion_id"], name: "index_content_lengths_on_audio_file_id_and_codec_conversion_id", unique: true
    t.index ["audio_file_id"], name: "index_content_lengths_on_audio_file_id"
    t.index ["codec_conversion_id"], name: "index_content_lengths_on_codec_conversion_id"
  end

  create_table "cover_filenames", force: :cascade do |t|
    t.string "filename", null: false
    t.index ["filename"], name: "index_cover_filenames_on_filename", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "cron"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.string "normalized_name", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true
    t.index ["normalized_name"], name: "index_genres_on_normalized_name"
  end

  create_table "genres_tracks", id: false, force: :cascade do |t|
    t.bigint "track_id", null: false
    t.bigint "genre_id", null: false
    t.index ["genre_id"], name: "index_genres_tracks_on_genre_id"
    t.index ["track_id", "genre_id"], name: "index_genres_tracks_on_track_id_and_genre_id", unique: true
    t.index ["track_id"], name: "index_genres_tracks_on_track_id"
  end

  create_table "image_types", force: :cascade do |t|
    t.string "extension", null: false
    t.string "mimetype", null: false
    t.index ["extension"], name: "index_image_types_on_extension", unique: true
  end

  create_table "images", force: :cascade do |t|
    t.bigint "image_type_id", null: false
    t.index ["image_type_id"], name: "index_images_on_image_type_id"
  end

  create_table "labels", force: :cascade do |t|
    t.string "name", null: false
    t.string "normalized_name", null: false
    t.index ["normalized_name"], name: "index_labels_on_normalized_name"
  end

  create_table "locations", force: :cascade do |t|
    t.string "path", null: false
    t.index ["path"], name: "index_locations_on_path", unique: true
  end

  create_table "rescan_runners", force: :cascade do |t|
    t.text "warning_text"
    t.text "error_text"
    t.integer "processed", default: 0, null: false
    t.boolean "running", default: false, null: false
    t.datetime "finished_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "track_artists", force: :cascade do |t|
    t.bigint "track_id", null: false
    t.bigint "artist_id", null: false
    t.string "name", null: false
    t.integer "role", null: false
    t.integer "order", null: false
    t.string "normalized_name", null: false
    t.index ["artist_id"], name: "index_track_artists_on_artist_id"
    t.index ["normalized_name"], name: "index_track_artists_on_normalized_name"
    t.index ["track_id", "artist_id", "name", "role"], name: "index_track_artists_on_track_id_and_artist_id_and_name_and_role", unique: true
    t.index ["track_id"], name: "index_track_artists_on_track_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "title", null: false
    t.integer "number", null: false
    t.bigint "audio_file_id"
    t.bigint "album_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "review_comment"
    t.string "normalized_title", null: false
    t.index ["album_id"], name: "index_tracks_on_album_id"
    t.index ["audio_file_id"], name: "index_tracks_on_audio_file_id", unique: true
    t.index ["normalized_title"], name: "index_tracks_on_normalized_title"
  end

  create_table "transcoded_items", force: :cascade do |t|
    t.string "path", null: false
    t.datetime "last_used", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "audio_file_id", null: false
    t.bigint "codec_conversion_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["audio_file_id", "codec_conversion_id"], name: "index_transcoded_items_on_audio_file_id_and_codec_conversion_id", unique: true
    t.index ["audio_file_id"], name: "index_transcoded_items_on_audio_file_id"
    t.index ["codec_conversion_id"], name: "index_transcoded_items_on_codec_conversion_id"
    t.index ["path"], name: "index_transcoded_items_on_path", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "permission", default: 0, null: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "album_artists", "albums"
  add_foreign_key "album_artists", "artists"
  add_foreign_key "album_labels", "albums"
  add_foreign_key "album_labels", "labels"
  add_foreign_key "albums", "images"
  add_foreign_key "artists", "images"
  add_foreign_key "audio_files", "codecs"
  add_foreign_key "audio_files", "locations"
  add_foreign_key "auth_tokens", "users"
  add_foreign_key "codec_conversions", "codecs", column: "resulting_codec_id"
  add_foreign_key "content_lengths", "audio_files"
  add_foreign_key "content_lengths", "codec_conversions"
  add_foreign_key "genres_tracks", "genres"
  add_foreign_key "genres_tracks", "tracks"
  add_foreign_key "images", "image_types"
  add_foreign_key "track_artists", "artists"
  add_foreign_key "track_artists", "tracks"
  add_foreign_key "tracks", "albums"
  add_foreign_key "tracks", "audio_files"
  add_foreign_key "transcoded_items", "audio_files"
  add_foreign_key "transcoded_items", "codec_conversions"
end
