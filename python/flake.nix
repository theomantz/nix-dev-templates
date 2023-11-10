{
    description = "A nix-flake for python development using poetry";

    inputs = {
        nixpkgs = {url = "github:NixOS/nixpkgs/nixos-unstable"; };
        flake-utils = {url = "github:numtide/flake-utils"; };
        poetry2nix = {
            url = "github:nix-community/poetry2nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, flake-utils, poetry2nix, ... }:
        flake-utils.lib.eachDefaultSystem (system: 
            let 
                pkgs = nixpkgs.legacyPackages.${system};

                pythonVersion = "39";

                # shown here: https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md

                # overlays = [
                #     (self: super: {
                #         poetry2nix = super.poetry2nix.overrideScope' (p2nixself: p2nixsuper: {
                #             defaultPoetryOverrides = p2nixsuper.defaultPoetryOverrides.extend (pyself: pysuper: {
                #                 python = python;
                #                 package = super.package.overridePythonAttrs (oldAttrs: {});
                #             });
                #         });
                #     })
                # ];

                # projectDir = self;
                packageName = "package-name";

                inherit (poetry2nix.lib.mkPoetry2nix { inherit pkgs; }) mkPoetryApplication;

                in { 

                    packages = {
                        packageName = mkPoetryApplication {
                            projectDir = self;
                            python = pkgs."python${pythonVersion}";
                        };
                        default = self.packages.${system}.${packageName};
                    };

                    # defaultPackage = self.packages.${system}.${packageName};

                    devShells.default = pkgs.mkShell {
                       inputsFrom = [ self.packages.${system}.${packageName} ];
                       packages = [ pkgs.poetry ];
                    };
                }
        
        );

}