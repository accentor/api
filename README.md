# Accentor API

API for Accentor, a modern music server focusing on metadata.

## Why use Accentor?
Accentor gives you complete control over your music. You can build
your own collection (with good old CD's, bandcamp downloads, ...) in
the sound quality that you want and stream it either through the [web
frontend](https://github.com/accentor/web) or [android
app](https://github.com/accentor/android).

Accentor is focused on metadata. We allow you to add detailed metadata
to your music collection, beyond what the tags inside an audio file
are capable of. Album and tracks can have multiple artists with a
different name on different albums/tracks, albums can have multiple
labels and tracks can have multiple genres.

The metadata is completely in your control: you can edit it however
you want.

## How to deploy

1. Make sure you have the correct dependencies installed. This is
   mostly ffmpeg and ruby.
1. Create a checkout of the code.
1. Install all ruby dependencies with `bundle install`.
1. Setup the database. Only postgresql is supported. Don't forget to
   run `rails db:setup`.
1. Make sure to perform migrations before starting the server. Also
   run the `ffmpeg:check_version` rake task.
1. Run `puma -C config/puma.rb` to start the server. You probably want
   to set the following environment variables:
    * DATABASE_URL
    * FFMPEG_LOG_LOCATION
    * RAILS_STORAGE_PATH
    * FFMPEG_VERSION_LOCATION
    * RAILS_TRANSCODE_CACHE
    * BOOTSNAP_CACHE_DIR
    * PIDFILE
    * RACK_ENV
    * RAILS_ENV
    * RAILS_LOG_TO_STDOUT

## Local development
To run and develop locally:
1. Make sure you are running [the correct version of
   ruby](https://github.com/accentor/api/blob/develop/.ruby-version).
1. Install all dependencies with `bundle install`
1. Make sure you have postgresql is running and add a role `accentor`
   with password `accentor` (This role should have the permission to
   login and createdb)
1. Make sure you have [ffmpeg](https://ffmpeg.org/download.html)
   installed, this is needed to calculate file length and convert
   audio.
1. Setup the local database with `rails db:setup`. This will also
  [seed](https://github.com/accentor/api/blob/develop/db/seeds.rb) the
  database with an admin account and some starting points for the
  application.

Once you've done this, you can always run a local server with `rails server`

## Help

Have a question? You can ask it through [GitHub
discussions](https://github.com/accentor/api/discussions) or in the
[Matrix channel](https://matrix.to/#/!PCYHOaWItkVRNacTSv:vanpetegem.me?via=vanpetegem.me&via=matrix.org).

Think you have noticed a bug or thought of a great feature we can add?
[Create an issue](https://github.com/accentor/api/issues/new/choose).
