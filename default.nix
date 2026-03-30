# This file describes your repository contents.
# It should return a set of nix derivations
# and optionally the special attributes `lib`, `modules` and `overlays`.
# It should NOT import <nixpkgs>. Instead, you should take pkgs as an argument.
# Having pkgs default to <nixpkgs> is fine though, and it lets you use short
# commands such as:
#     nix-build -A mypackage

{ pkgs ? import <nixpkgs> { } }:

let
  python3Packages = pkgs.python312Packages.override {
    overrides = self: super: {
      scanpy = super.scanpy.overrideAttrs (oldAttrs: {
        doCheck = false;
        doInstallCheck = false;
      });
      pynndescent = super.pynndescent.overrideAttrs (oldAttrs: {
        doCheck = false;
        doInstallCheck = false;
      });
      biopython = super.biopython.overrideAttrs (oldAttrs: {
        doCheck = false;
        checkPhase = "true";
        doInstallCheck = false;
        installCheckPhase = "true";
        meta = oldAttrs.meta // { broken = false; };
      });
      hatch-min-requirements = super.hatch-min-requirements.overrideAttrs (oldAttrs: {
        propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or [ ]) ++ [ self.tomlkit ];
      });
      alphagenome = self.callPackage ./pkgs/alphagenome { };
      bamnostic = self.callPackage ./pkgs/bamnostic { };
      bioblend = self.callPackage ./pkgs/bioblend { };
      biothings_client = self.callPackage ./pkgs/biothings_client { };
      buckaroo = self.callPackage ./pkgs/buckaroo { };
      datacache = self.callPackage ./pkgs/datacache { };
      ddqc = self.callPackage ./pkgs/ddqc { };
      demuxEM = self.callPackage ./pkgs/demuxEM { };
      episcanpy = self.callPackage ./pkgs/episcanpy { };
      fancycompleter = self.callPackage ./pkgs/fancycompleter { };
      gtfparse = self.callPackage ./pkgs/gtfparse { };
      gwaslab = self.callPackage ./pkgs/gwaslab { };
      harmonypy = self.callPackage ./pkgs/harmonypy { };
      liftover = self.callPackage ./pkgs/liftover { };
      louvain = self.callPackage ./pkgs/louvain {
        igraph = pkgs.igraph;
        python-igraph = self.igraph;
        ddt = self.ddt;
        setuptools-scm = self.setuptools-scm;
      };
      memoized-property = self.callPackage ./pkgs/memoized-property { };
      mygene = self.callPackage ./pkgs/mygene { };
      pegasusio = self.callPackage ./pkgs/pegasusio { };
      pegasuspy = self.callPackage ./pkgs/pegasuspy { };
      pipe-operator = self.callPackage ./pkgs/pipe-operator { };
      pyensembl = self.callPackage ./pkgs/pyensembl { };
      pyjaspar = self.callPackage ./pkgs/pyjaspar { };
      pyrepl = self.callPackage ./pkgs/pyrepl { };
      redun = self.callPackage ./pkgs/redun { };
      scikit-allel = self.callPackage ./pkgs/scikit-allel { };
      session-info = self.callPackage ./pkgs/session-info { };
      formulaic-contrasts = self.callPackage ./pkgs/formulaic-contrasts { };
      pydeseq2 = self.callPackage ./pkgs/pydeseq2 { };
      tinytimer = self.callPackage ./pkgs/tinytimer { };
      tuspy = self.callPackage ./pkgs/tuspy { };
      numcodecs = self.callPackage ./pkgs/numcodecs { };
      zarr = self.callPackage ./pkgs/zarr { };
    };
  };

  rPackages = let
    self = pkgs.rPackages // rec {
      callPackage = pkgs.newScope self;
      MRMix = callPackage ./pkgs/MRMix { };
      MRPRESSO = callPackage ./pkgs/MRPRESSO { };
      RadialMR = callPackage ./pkgs/RadialMR { };
      twosamplemr = callPackage ./pkgs/twosamplemr { };
    };
  in pkgs.rPackages.override {
    overrides = {
      inherit (self) MRMix MRPRESSO RadialMR twosamplemr;
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
  bamnostic = python3Packages.bamnostic;
  bioblend = python3Packages.bioblend;
  biothings_client = python3Packages.biothings_client;
  buckaroo = python3Packages.buckaroo;
  datacache = python3Packages.datacache;
  ddqc = python3Packages.ddqc;
  demuxEM = python3Packages.demuxEM;
  episcanpy = python3Packages.episcanpy;
  fancycompleter = python3Packages.fancycompleter;
  gtfparse = python3Packages.gtfparse;
  gwaslab = python3Packages.gwaslab;
  harmonypy = python3Packages.harmonypy;
  liftover = python3Packages.liftover;
  louvain = python3Packages.louvain;
  memoized-property = python3Packages.memoized-property;
  mygene = python3Packages.mygene;
  pegasusio = python3Packages.pegasusio;
  pegasuspy = python3Packages.pegasuspy;
  pipe-operator = python3Packages.pipe-operator;
  pyensembl = python3Packages.pyensembl;
  pyjaspar = python3Packages.pyjaspar;
  pyrepl = python3Packages.pyrepl;
  redun = python3Packages.redun;
  scikit-allel = python3Packages.scikit-allel;
  session-info = python3Packages.session-info;
  formulaic-contrasts = python3Packages.formulaic-contrasts;
  pydeseq2 = python3Packages.pydeseq2;
  tinytimer = python3Packages.tinytimer;
  tuspy = python3Packages.tuspy;
  numcodecs = python3Packages.numcodecs;
  zarr = python3Packages.zarr;

  twosamplemr = rPackages.twosamplemr;
  MRMix = rPackages.MRMix;
  MRPRESSO = rPackages.MRPRESSO;
  RadialMR = rPackages.RadialMR;
}
