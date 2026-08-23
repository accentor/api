{
  description = "Accentor API";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    bundix = {
      url = "github:inscapist/bundix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    let
      rubyForPkgs = pkgs: pkgs.ruby_4_0.override { jemallocSupport = true; };
      gemsForPkgs = pkgs: pkgs.bundlerEnv {
        name = "accentor-api-env";
        ruby = rubyForPkgs pkgs;
        gemfile = ./Gemfile;
        lockfile = ./Gemfile.lock;
        gemset = ./gemset.nix;
        groups = [ "default" "development" "test" "production" ];
      };
    in
    {
      packages = builtins.mapAttrs
        (system: pkgs':
          let
            pkgs = pkgs'.extend (self: super: { bundix = inputs.bundix; });
          in
          {
            accentor-api = pkgs.callPackage ./default.nix { accentor-api-env = gemsForPkgs pkgs; };
            default = inputs.self.packages.${system}.accentor-api;
          })
        inputs.nixpkgs.legacyPackages;
      devShells = builtins.mapAttrs
        (system: pkgs':
          let
            pkgs = pkgs'.appendOverlays [ (self: super: { bundix = inputs.bundix; }) inputs.devshell.overlays.default ];
          in
          {
            accentor-api = pkgs.callPackage ./shell.nix { accentor-api-env = gemsForPkgs pkgs; };
            default = inputs.self.devShells.${system}.accentor-api;
            deps = pkgs.devshell.mkShell { packages = [ (rubyForPkgs pkgs) pkgs.bundix ]; };
          })
        inputs.nixpkgs.legacyPackages;
    };
}
