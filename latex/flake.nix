{
    description = "A Nix-flake-based LaTeX development environment";

    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    inputs.flake-utils.url = "github:numtide/flake-utils";

    outputs = { self, nixpkgs, flake-utils }:
        flake-utils.lib.eachDefaultSystem (system: 
            let
                pkgs = import nixpkgs { inherit system; };

                latex-packages = with pkgs; [
                    (texlive.combine {
                        inherit (texlive)
                        scheme-medium
                        dvisvgm
                        dvipng
                        chktex
                        xetex
                        luatex
                        wrapfig
                        amsmath 
                        ulem 
                        hyperref 
                        capt-of 
                        geometry;
                    })
                    which
                    python39Packages.pygments
                ];

                dev-packages = with pkgs; [
                    texlab
                    zathura
                    wmctrl
                ];
            in
            rec {
                devShells.default = pkgs.mkShell {
                    buildInputs = [ latex-packages dev-packages ];
                    packages = latex-packages;
                };
            }
        );
}
