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

ActiveRecord::Schema[7.1].define(version: 2024_07_06_100659) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
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
    t.date "release", default: "0000-01-01", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.text "error_backtrace", array: true
    t.uuid "process_id"
    t.interval "duration"
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
    t.integer "lock_type", limit: 2
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.uuid "locked_by_id"
    t.datetime "locked_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
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

  create_table "playlist_items", force: :cascade do |t|
    t.bigint "playlist_id", null: false
    t.integer "item_id", null: false
    t.string "item_type", null: false
    t.integer "order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["playlist_id", "item_id"], name: "index_playlist_items_on_playlist_id_and_item_id", unique: true
    t.index ["playlist_id"], name: "index_playlist_items_on_playlist_id"
  end

  create_table "playlists", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.integer "playlist_type", null: false
    t.bigint "user_id", null: false
    t.integer "access", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_playlists_on_user_id"
  end

  create_table "plays", force: :cascade do |t|
    t.bigint "track_id", null: false
    t.bigint "user_id", null: false
    t.datetime "played_at", precision: nil, null: false
    t.index ["track_id"], name: "index_plays_on_track_id"
    t.index ["user_id", "track_id"], name: "index_plays_on_user_id_and_track_id"
    t.index ["user_id"], name: "index_plays_on_user_id"
  end

  create_table "rescan_runners", force: :cascade do |t|
    t.text "warning_text"
    t.text "error_text"
    t.integer "processed", default: 0, null: false
    t.boolean "running", default: false, null: false
    t.datetime "finished_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "location_id", null: false
    t.index ["location_id"], name: "index_rescan_runners_on_location_id"
  end

  create_table "track_artists", force: :cascade do |t|
    t.bigint "track_id", null: false
    t.bigint "artist_id", null: false
    t.string "name", null: false
    t.integer "role", null: false
    t.integer "order", null: false
    t.string "normalized_name", null: false
    t.boolean "hidden", default: false, null: false
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
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "review_comment"
    t.string "normalized_title", null: false
    t.index ["album_id"], name: "index_tracks_on_album_id"
    t.index ["audio_file_id"], name: "index_tracks_on_audio_file_id", unique: true
    t.index ["normalized_title"], name: "index_tracks_on_normalized_title"
  end

  create_table "transcoded_items", force: :cascade do |t|
    t.string "path", null: false
    t.datetime "last_used", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "audio_file_id", null: false
    t.bigint "codec_conversion_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
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
  add_foreign_key "playlist_items", "playlists"
  add_foreign_key "playlists", "users"
  add_foreign_key "plays", "tracks"
  add_foreign_key "plays", "users"
  add_foreign_key "rescan_runners", "locations"
  add_foreign_key "track_artists", "artists"
  add_foreign_key "track_artists", "tracks"
  add_foreign_key "tracks", "albums"
  add_foreign_key "tracks", "audio_files"
  add_foreign_key "transcoded_items", "audio_files"
  add_foreign_key "transcoded_items", "codec_conversions"
end
