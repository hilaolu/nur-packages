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
      datacache = self.callPackage ./pkgs/datacache { };
      fancycompleter = self.callPackage ./pkgs/fancycompleter { };
      gtfparse = self.callPackage ./pkgs/gtfparse { };
      gwaslab = self.callPackage ./pkgs/gwaslab { };
      liftover = self.callPackage ./pkgs/liftover { };
      memoized-property = self.callPackage ./pkgs/memoized-property { };
      pipe-operator = self.callPackage ./pkgs/pipe-operator { };
      pyensembl = self.callPackage ./pkgs/pyensembl { };
      pyrepl = self.callPackage ./pkgs/pyrepl { };
      redun = self.callPackage ./pkgs/redun { };
      scikit-allel = self.callPackage ./pkgs/scikit-allel { };
      tinytimer = self.callPackage ./pkgs/tinytimer { };
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
  datacache = python3Packages.datacache;
  fancycompleter = python3Packages.fancycompleter;
  gtfparse = python3Packages.gtfparse;
  gwaslab = python3Packages.gwaslab;
  liftover = python3Packages.liftover;
  memoized-property = python3Packages.memoized-property;
  pipe-operator = python3Packages.pipe-operator;
  pyensembl = python3Packages.pyensembl;
  pyrepl = python3Packages.pyrepl;
  redun = python3Packages.redun;
  scikit-allel = python3Packages.scikit-allel;
  tinytimer = python3Packages.tinytimer;
  tuspy = python3Packages.tuspy;
}
