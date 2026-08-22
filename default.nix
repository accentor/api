{ stdenv
, lib
, accentor-api-env
}:

let
  rootFiles = lib.fileset.fileFilter (file: builtins.elem file.name [ "config.ru" "Gemfile" "Gemfile.lock" "gemset.nix" "Rakefile" ]) ./.;
  srcFiles = lib.fileset.unions [ rootFiles ./app ./bin ./config ./db ./lib ./public ];
in
stdenv.mkDerivation {
  pname = "accentor-api";
  version = "0.24.0";
  src = lib.fileset.toSource { root = ./.; fileset = srcFiles; };

  buildPhase = ''
    # Compile bootsnap cache
    ${accentor-api-env}/bin/bundle exec bootsnap precompile --gemfile app/ lib/
  '';

  installPhase = ''
    mkdir $out
    cp -r * $out
  '';

  passthru.env = accentor-api-env;
}
