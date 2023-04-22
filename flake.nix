{
  description = "Accentor API";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = { self, nixpkgs, devshell, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ devshell.overlays.default ]; };
        gems = pkgs.bundlerEnv rec {
          name = "accentor-api-env";
          ruby = pkgs.ruby_3_2;
          gemfile = ./Gemfile;
          lockfile = ./Gemfile.lock;
          gemset = ./gemset.nix;
          groups = [ "default" "development" "test" "production" ];
        };
      in
      {
        packages = rec {
          default = accentor-api;
          accentor-api = pkgs.stdenv.mkDerivation rec {
            pname = "accentor-api";
            version = "0.18.2";

            src = pkgs.lib.cleanSourceWith { filter = name: type: !(builtins.elem name [ ".github" "flake.lock" "flake.nix" ]); src = ./.; name = "source"; };

            buildPhase = ''
              # Compile bootsnap cache
              ${gems}/bin/bundle exec bootsnap precompile --gemfile app/ lib/
            '';

            installPhase = ''
              mkdir $out
              cp -r * $out
            '';

            passthru.env = gems;
          };
        };

        devShells = rec {
          default = accentor-api;
          accentor-api = pkgs.devshell.mkShell {
            name = "Accentor API";
            packages = [
              gems
              (pkgs.lowPrio gems.wrappedRuby)
              pkgs.ffmpeg
              pkgs.nixpkgs-fmt
              pkgs.postgresql_14
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
                  ${pkgs.ruby_3_1}/bin/bundle lock
                  ${pkgs.bundix}/bin/bundix
                '';
              }
            ];
          };
        };
      }
    );
}
