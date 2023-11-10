{
    description = "A nix-flake for python development using poetry";

    inputs = {
        nixpkgs = {url = "github:NixOS/nixpkgs/nixos-unstable"; };
        flake-utils = {url = "github:numtide/flake-utils"; };
    };

    outputs = { self, nixpkgs, flake-utils, ... }:
        flake-utils.lib.eachDefaultSystem (system: 
            let 
                pkgs = import nixpkgs { inherit system; };

                # shown here: https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md
                pythonVersion = 39;

                python = pkgs."python${toString pythonVersion}";

                overlays = [
                    (self: super: {
                        poetry2nix = super.poetry2nix.overrideScope' (p2nixself: p2nixsuper: {
                            defaultPoetryOverrides = p2nixsuper.defaultPoetryOverrides.extend (pyself: pysuper: {
                                python = python;
                                package = super.package.overridePythonAttrs (oldAttrs: {});
                            });
                        });
                    })
                ];

                projectDir = ./.;
                packageName = "package-name";

                in { 

                    packages.${packageName} = pkgs.poetry2nix.mkPoetryApplication {
                        inherit python overlays projectDir;
                        # non-python dependencies
                        propogatedBuildInputs = [];
                    };

                    defaultPackage = self.packages.${system}.${packageName};

                    devShell = pkgs.mkShell {
                        buildInputs = [
                            (pkgs.poetry2nix.mkPoetryShell {
                                inherit python projectDir overlays;
                            })
                            pkgs."python${toString pythonVersion}Packages".poetry
                        ];
                    };
                }
        
        );

}