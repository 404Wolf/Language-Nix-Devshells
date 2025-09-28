{
  description = "Quarto devShell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        treefmtconfig = treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs = {
            nixfmt.enable = true;
            mdformat.enable = true;
            yamlfmt.enable = true;
            prettier.enable = true;
          };
        };
      in
      {
        formatter = treefmtconfig.config.build.wrapper;

        packages = {
          default = pkgs.callPackage ./nix/build.nix { };
        };
        devShells = {
          default = pkgs.mkShell {
            packages = (
              with pkgs;
              [
                texliveFull
                quarto
                wkhtmltopdf
              ]
            );
          };
        };
      }
    );
}
