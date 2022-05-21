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
        pkgs = import nixpkgs { inherit system; overlays = [ devshell.overlay ]; };
        gems = pkgs.bundlerEnv rec {
          name = "accentor-api-env";
          ruby = pkgs.ruby_3_1;
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
            version = "0.17.2";

            src = pkgs.lib.cleanSourceWith { filter = name: type: !(builtins.elem name [ ".github" "flake.lock" "flake.nix" ]); src = ./.; name = "source"; };

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
            imports = [ "${devshell}/extra/language/c.nix" ];
            packages = with pkgs; [
              (lowprio binutils)
              findutils
              gnumake
              ruby_3_1
              bundix
              ffmpeg
              nixpkgs-fmt
              postgresql_14
            ];
            env = [
              {
                name = "GEM_HOME";
                eval = "$PRJ_DATA_DIR/bundle/$(ruby -e 'puts RUBY_VERSION')";
              }
              {
                name = "PGDATA";
                eval = "$PRJ_DATA_DIR/postgres";
              }
              {
                name = "DATABASE_HOST";
                eval = "$PGDATA";
              }
              {
                name = "PATH";
                prefix = "$GEM_HOME/bin";
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
                  [ ! -d $PGDATA ] && setup-db
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
            ];
            language.c.compiler = pkgs.gcc;
          };
        };
      }
    );
}
