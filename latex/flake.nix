{
    description = "A Nix-flake-based LaTeX development environment";

    input.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    outputs = { self, nixpkgs }:
    let
        tex = ( pkgs.texlive.combine {
            inherit ( pkgs.texlive.combine ) scheme-medium
            dvisvgm dvipng chktex xetex luatex
            wrapfig amsmath ulem hyperref capt-of geometry;
        });
        supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
        forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems ( system: f {
            pkgs = import nixpkgs { inherit tex system; };
        });
    in

    devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
            packages = with pkgs; [ tex ]
        }
    })
}