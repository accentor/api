# Accentor API

[![CI](https://github.com/accentor/api/actions/workflows/ci.yml/badge.svg)](https://github.com/accentor/api/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/accentor/api/branch/main/graph/badge.svg?token=9NQX5904SK)](https://codecov.io/gh/accentor/api)

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
1. Run `puma -C config/puma.rb` to start the server. You can use any
   other application server as well, but there is no configuration
   provided.
1. Run `good_job start` to start a background worker.
   In Accentor, all jobs are handled by the following 4 queues:
   * within_30_seconds
   * within_5_minutes
   * within_30_minutes
   * whenever

   These queue names refer to the period in which a job should be
   picked up by a worker. If you want/need to manage the available
   workers in more details, you can specify the availability of
   workers per process or per thread with `GOOD_JOB_QUEUES`. 
   Check the [good job docs](https://github.com/bensheldon/good_job#optimize-queues-threads-and-processes)
   for the possibilities.
1. You probably want to set the following environment variables when
   running:
    * DATABASE_URL
    * RACK_ENV
    * RAILS_ENV
    * SECRET_KEY_BASE
    
    You can generate a new `SECRET_KEY_BASE` using `bin/rails secret`.
    For optimal caching, this key should be stable.
    
    Optionally set the following variables to control where Accentor
    stores its files:
    
    * FFMPEG_LOG_LOCATION
    * RAILS_STORAGE_PATH
    * RAILS_TRANSCODES_PATH
    * BOOTSNAP_CACHE_DIR
    * PIDFILE
    * RAILS_LOG_TO_STDOUT
1. This leaves you with a server running on port 3000. Use a reverse
   proxy like Apache or nginx to route your traffic. If you are
   deploying the web frontend an the same subdomain, you can match the
   requested path on `/api` and `/rails` and only proxy those
   requests.

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

If you use nix on your local machine, you can also use the devShell provided by [`flake.nix`](./flake.nix).

## Help

Have a question? You can ask it through [GitHub
discussions](https://github.com/accentor/api/discussions) or in the
[Matrix channel](https://matrix.to/#/!PCYHOaWItkVRNacTSv:vanpetegem.me?via=vanpetegem.me&via=matrix.org).

Think you have noticed a bug or thought of a great feature we can add?
[Create an issue](https://github.com/accentor/api/issues/new/choose).
