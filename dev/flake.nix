{
  description = "Accentor API development";

  inputs = {
    super = {
      url = "../";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

  outputs = inputs: {
    devShells = builtins.mapAttrs (
      system: pkgs':
      let
        pkgs = pkgs'.appendOverlays [
          (self: super: {
            bundix = inputs.bundix;
          })
          inputs.super.overlays.default
          inputs.devshell.overlays.default
        ];
      in
      {
        accentor-api = pkgs.callPackage ./shell.nix { };
        default = inputs.self.devShells.${system}.accentor-api;
        deps = pkgs.devshell.mkShell {
          packages = [
            pkgs.accentor-api.ruby
            pkgs.bundix
          ];
        };
      }
    ) inputs.nixpkgs.legacyPackages;
  };
}
