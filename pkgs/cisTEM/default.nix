{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  fftwFloat,
  libtiff,
  wxGTK32,
  xorg,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "cisTEM";
  version = "2.0.0-alpha-unstable-2026-06-16";

  src = fetchFromGitHub {
    owner = "hilaolu";
    repo = "cisTEM";
    rev = "unbend";
    hash = "sha256-a227Ohw1gzm98jiqkwjxyWCtMNbFV3L+3VMx+zPPUpk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    fftwFloat
    libtiff
    wxGTK32
    xorg.libX11
    zlib
  ];

  preAutoreconf = ''
    mkdir -p m4
    cp ax_cuda.m4 m4/ax_cuda.m4
  '';

  configureFlags = [
    "--with-fftw-dir=${fftwFloat}"
    "--with-wx-config=${wxGTK32}/bin/wx-config"
  ];

  enableParallelBuilding = true;

  CXXFLAGS = "-include cstdint";

  meta = {
    description = "Cryo-EM image processing suite for single-particle reconstructions";
    homepage = "https://github.com/timothygrant80/cisTEM";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
    mainProgram = "cisTEM";
    platforms = lib.platforms.linux;
  };
}
