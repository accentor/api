{
  description = "Accentor API";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = inputs: {
    packages = builtins.mapAttrs (system: pkgs: {
      accentor-api = pkgs.callPackage ./default.nix { };
      default = inputs.self.packages.${system}.accentor-api;
    }) inputs.nixpkgs.legacyPackages;
    overlays.default = (
      self: super: {
        accentor-api = self.callPackage ./default.nix { };
      }
    );
  };
}
