{
  description = "Latex DevShell";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};

      latex-indent = pkgs.symlinkJoin {
        name = "latex-indent";
        paths = [pkgs.perl538Packages.LatexIndent];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          ln -s $out/bin/latexindent.pl $out/bin/latexindent
        '';
      };
    in {
      devShells = {
        default = pkgs.mkShell {
          packages = with pkgs;
            [texlab]
            + [latex-indent];
        };
      };
    });
}
