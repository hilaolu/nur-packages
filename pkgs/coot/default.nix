{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, autoreconfHook
, bc
, blas
, cmake
, gfortran
, m4
, pkg-config
, makeWrapper
, swig
, boost
, cairo
, coordgenlibs
, curl
, eigen
, gemmi
, glm
, glib
, gsl
, gtk4
, libepoxy
, libpng
, librsvg
, libGL
, python312
, sqlite
, wrapGAppsHook4
, xorg
}:

let
  fftw2 = stdenv.mkDerivation rec {
    pname = "fftw2-single";
    version = "2.1.5";

    src = fetchurl {
      url = "http://www.fftw.org/fftw-${version}.tar.gz";
      sha256 = "0c160b38kdi41iijwbn7966m2i3a9blz6gkq2s8vky3x3jp7y1gq";
    };

    configureFlags = [
      "--enable-float"
      "--enable-shared"
      "--disable-fortran"
    ];
  };

  mmdb2 = stdenv.mkDerivation rec {
    pname = "mmdb2";
    version = "2.0.22";

    src = fetchurl {
      url = "https://ftp.ccp4.ac.uk/opensource/mmdb2-${version}.tar.gz";
      sha256 = "1qll9aydvh572drv1fwl8syv1nwzcjn08qxp9v0prwsvas8kwlvh";
    };

    nativeBuildInputs = [
      pkg-config
    ];
  };

  libccp4 = stdenv.mkDerivation rec {
    pname = "libccp4";
    version = "8.0.0";

    src = fetchurl {
      url = "https://ftp.ccp4.ac.uk/opensource/libccp4-${version}.tar.gz";
      sha256 = "0bgz499svya03ls41cp53gc77igajvp7rayy55iqd80jcvl3m0fb";
    };

    nativeBuildInputs = [
      cmake
      gfortran
      m4
      pkg-config
    ];

    buildInputs = [
      mmdb2
    ];

    postPatch = ''
      substituteInPlace ccp4/library_utils.c \
        --replace-fail "  int putenv ();" "  int putenv (char *);"
    '';

    cmakeFlags = [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
      "-DFORTRAN_LIB=OFF"
    ];

    postInstall = ''
      ln -s ccp4c.pc "$out/lib/pkgconfig/libccp4c.pc"
    '';
  };

  ssm = stdenv.mkDerivation rec {
    pname = "ssm";
    version = "1.4.0";

    src = fetchurl {
      url = "https://ftp.ccp4.ac.uk/opensource/ssm-${version}.tar.gz";
      sha256 = "0f427a4jhwizrcs7c8kn3m5rkvlqkn4cb9sc0sx04rvilbb8za6y";
    };

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      libccp4
      mmdb2
    ];

    configureFlags = [
      "--enable-ccp4"
    ];
  };

  ccp4Clipper = stdenv.mkDerivation rec {
    pname = "ccp4-clipper";
    version = "2.1.20201109";

    src = fetchurl {
      url = "https://ftp.ccp4.ac.uk/opensource/clipper-${version}.tar.gz";
      sha256 = "0w75acq0hdmy9r2paxkm6zp9ffzqlk2ywq15jw5f9v09lfynw9q1";
    };

    nativeBuildInputs = [
      pkg-config
    ];

    buildInputs = [
      fftw2
      libccp4
      mmdb2
    ];

    configureFlags = [
      "--enable-ccp4"
      "--enable-cif"
      "--enable-cns"
      "--enable-minimol"
      "--enable-mmdb"
      "--with-fftw-prefix=${fftw2}"
    ];
  };

  python = python312.withPackages (ps: with ps; [
    numpy
    pillow
    pygobject3
    rdkit
  ]);

  boostWithPython = boost.override {
    enablePython = true;
    python = python312;
  };

  rdkit = python312.pkgs.rdkit;
  pygobject3 = python312.pkgs.pygobject3;
in
stdenv.mkDerivation rec {
  pname = "coot";
  version = "1.1.20";

  src = fetchFromGitHub {
    owner = "pemsley";
    repo = "coot";
    rev = "Release-${version}";
    hash = "sha256-i2WrJqsT/R0VIv2VK0C1Pz0seX8t/fuAm11AdNU099A=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bc
    pkg-config
    makeWrapper
    python
    swig
    wrapGAppsHook4
  ];

  buildInputs = [
    boostWithPython
    blas
    cairo
    coordgenlibs
    ccp4Clipper
    curl
    eigen
    fftw2
    gemmi
    glib
    glm
    gsl
    gtk4
    libccp4
    libepoxy
    libGL
    libpng
    librsvg
    mmdb2
    pygobject3.dev
    python
    rdkit
    sqlite
    ssm
    xorg.libX11
  ];

  configureFlags = [
    "--with-boost=${boostWithPython}"
    "--with-boost-libdir=${boostWithPython}/lib"
    "--with-fftw-prefix=${fftw2}"
    "--with-gemmi=${gemmi}"
    "--with-glm=${glm}"
    "--with-rdkit-prefix=${rdkit}"
    "--without-guile"
    "--without-netcdf"
    "--with-sound=false"
    "--without-vte"
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail 'with_sound="withval"' 'with_sound="$withval"'

    substituteInPlace configure.ac \
      --replace-fail " -lRDKitRingDecomposerLib" ""

    substituteInPlace src/glade-callbacks.cc \
      --replace-fail "g_warning(mess.c_str());" 'g_warning("%s", mess.c_str());'
  '';

  postInstall = ''
    for program in coot pyrogen; do
      wrapProgram "$out/bin/$program" \
        --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
        --prefix PYTHONPATH : "$PYTHONPATH:$out/lib/python${python312.pythonVersion}/site-packages:$out/lib/python${python312.pythonVersion}/site-packages/coot"
    done
  '';

  meta = {
    description = "Macromolecular crystallography model-building toolkit";
    homepage = "https://github.com/pemsley/coot";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "coot";
    platforms = lib.platforms.linux;
  };
}
