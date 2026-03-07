# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

let
  python3Packages = pkgs.python3Packages.override {
    overrides = self: super: {
      alphagenome = self.callPackage ./pkgs/alphagenome { };
      bioblend = self.callPackage ./pkgs/bioblend { };
      buckaroo = self.callPackage ./pkgs/buckaroo { };
      fancycompleter = self.callPackage ./pkgs/fancycompleter { };
      pipe-operator = self.callPackage ./pkgs/pipe-operator { };
      pyrepl = self.callPackage ./pkgs/pyrepl { };
      redun = self.callPackage ./pkgs/redun { };
      tuspy = self.callPackage ./pkgs/tuspy { };
    };
  };
in
{
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  example-package = pkgs.callPackage ./pkgs/example-package { };
  foldit = pkgs.callPackage ./pkgs/foldit { };
  HMCL = pkgs.callPackage ./pkgs/HMCL { };
  zulu = pkgs.callPackage ./pkgs/zulu { };

  alphagenome = python3Packages.alphagenome;
  bioblend = python3Packages.bioblend;
  buckaroo = python3Packages.buckaroo;
  fancycompleter = python3Packages.fancycompleter;
  pipe-operator = python3Packages.pipe-operator;
  pyrepl = python3Packages.pyrepl;
  redun = python3Packages.redun;
  tuspy = python3Packages.tuspy;
}
