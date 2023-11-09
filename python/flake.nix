{
    description = "A nix-flake for python development using poetry";

    inputs = {
        nixpkgs = {url = "github:NixOS/nixpkgs/nixos-unstable"; };
        flake-utils = {url = "github:numtide/flake-utils"; };
    };

    outputs = { self, nixpkgs, flake-utils, ... }:
        flake-utils.lib.forEachSupportedSystem (system: 
            let 
                pkgs = import nixpkgs { inherit system; };

                # shown here: https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md
                pythonVersion = 39;

                python = pkgs."python${toString pythonVersion}";
                projectDir = ./.;
                overrides = pkgs.poetry2nix.overrides.withDefaults (final: prev {
                    # add your overrides here
                });


                packageName = "package-name";

                in { 

                    packages.${package-name} = pkgs.poetry2nix.mkPoetryApplication {
                        inherit python projectDir overrides;
                        # non-python dependencies
                        propogatedBuildInputs = [];
                    };

                    defaultPackage = self.packages.${system}.${packageName};

                    devShell = pkgs.mkShell {
                        buildInputs = [
                            (pkgs.poetry2nix.mkPoetryShell {
                                inherit python projectDir overrides;
                            })
                            pkgs."python${toString pythonVersion}Packages".poetry
                        ];
                    };
        });

}