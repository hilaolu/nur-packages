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
    owner = "timothygrant80";
    repo = "cisTEM";
    rev = "6c6eff601afc45f404bcd40ea2878619431a4789";
    hash = "sha256-TXLpH5hcipyxFatUe9VQoNKFOzW8FpU7VuCVjTbq3IA=";
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

  meta = {
    description = "Cryo-EM image processing suite for single-particle reconstructions";
    homepage = "https://github.com/timothygrant80/cisTEM";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
    mainProgram = "cisTEM";
    platforms = lib.platforms.linux;
  };
}
