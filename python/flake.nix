{
    description = "A nix-flake for python development using poetry";
    # doesnt work right now

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
                # packageName = "package-name";

                inherit (poetry2nix.lib.mkPoetry2Nix { inherit pkgs; }) mkPoetryApplication;
                pythonVersion = "39";
                in { 

                    packages = {
                        myapp = mkPoetryApplication { projectDir = self; };
                        default = self.packages.${system}.myapp;
                    };

                    # defaultPackage = self.packages.${system}.${packageName};

                    devShells.default = pkgs.mkShell {
                       inputsFrom = [ self.packages.${system}.myapp ];
                       packages = [ pkgs.poetry ];
                    };
                }
        
        );

}