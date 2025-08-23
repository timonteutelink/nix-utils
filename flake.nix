{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable-pkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    devenv.url = "github:cachix/devenv";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { flake-parts
    , nixpkgs
    , ...
    } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, moduleWithSystem, flake-parts-lib, ... }:
      let
        inherit (flake-parts-lib) importApply mkSubmoduleOptions;

        importApplyMod = file: importApply file { inherit withSystem moduleWithSystem importApply mkSubmoduleOptions; };

        import-files = (import ./nix/lib/import-files.nix { lib = nixpkgs.lib; }).import-files;

        modFiles = import-files { path = ./nix/flake; recursive = true; };
      in
      {
        imports = map importApplyMod modFiles ++ [ inputs.flake-parts.flakeModules.flakeModules ];

        systems = [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ];
      }
    );
}
