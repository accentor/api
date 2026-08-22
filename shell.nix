{ devshell
, lib
, accentor-api-env
, ffmpeg
, nixpkgs-fmt
, postgresql_18
, bundix
}:

let
  ruby = accentor-api-env.wrappedRuby;
in
devshell.mkShell {
  name = "Accentor API";
  packages = [
    accentor-api-env
    (lib.lowPrio ruby)
    ffmpeg
    nixpkgs-fmt
    postgresql_18
  ];
  env = [
    {
      name = "PGDATA";
      eval = "$PRJ_DATA_DIR/postgres";
    }
    {
      name = "DATABASE_HOST";
      eval = "$PGDATA";
    }
  ];
  commands = [
    {
      name = "pg:setup";
      category = "database";
      help = "Setup postgres in project folder";
      command = ''
        initdb --encoding=UTF8 --no-locale --no-instructions -U postgres
        echo "listen_addresses = ${"'"}${"'"}" >> $PGDATA/postgresql.conf
        echo "unix_socket_directories = '$PGDATA'" >> $PGDATA/postgresql.conf
        echo "CREATE USER accentor WITH PASSWORD 'accentor' CREATEDB;" | postgres --single -E postgres
      '';
    }
    {
      name = "pg:start";
      category = "database";
      help = "Start postgres instance";
      command = ''
        [ ! -d $PGDATA ] && pg:setup
        pg_ctl -D $PGDATA -U postgres start -l log/postgres.log
      '';
    }
    {
      name = "pg:stop";
      category = "database";
      help = "Stop postgres instance";
      command = ''
        pg_ctl -D $PGDATA -U postgres stop
      '';
    }
    {
      name = "pg:console";
      category = "database";
      help = "Open database console";
      command = ''
        psql --host $PGDATA -U postgres
      '';
    }
    {
      name = "gems:update";
      category = "dependencies";
      help = "Update the `Gemfile.lock` and `gemset.nix` files";
      command = ''
        ${ruby}/bin/bundle lock --add-checksums
        ${bundix}/bin/bundix
      '';
    }
  ];
}
