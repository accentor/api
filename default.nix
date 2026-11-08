{
  stdenv,
  lib,
  ruby_4_0,
  bundlerEnv,
}:

let
  rootFiles = lib.fileset.fileFilter (
    file:
    builtins.elem file.name [
      "config.ru"
      "Gemfile"
      "Gemfile.lock"
      "gemset.nix"
      "Rakefile"
    ]
  ) ./.;
  srcFiles = lib.fileset.unions [
    rootFiles
    ./app
    ./bin
    ./config
    ./db
    ./lib
    ./public
  ];
  ruby = ruby_4_0.override { jemallocSupport = true; };
  gems = bundlerEnv {
    inherit ruby;
    name = "accentor-api-env";
    gemfile = ./Gemfile;
    lockfile = ./Gemfile.lock;
    gemset = ./gemset.nix;
    groups = [
      "default"
      "development"
      "test"
      "production"
    ];
  };
in
stdenv.mkDerivation {
  pname = "accentor-api";
  version = "0.24.0";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = srcFiles;
  };

  buildPhase = ''
    # Compile bootsnap cache
    ${gems}/bin/bundle exec bootsnap precompile --gemfile app/ lib/
  '';

  installPhase = ''
    mkdir $out
    cp -r * $out
  '';

  passthru = {
    inherit ruby;
    env = gems;
  };
}
