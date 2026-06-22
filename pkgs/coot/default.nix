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
, boost178
, cairo
, coordgenlibs
, curl
, eigen
, freeglut
, gnome2
, glib
, goocanvas_2
, gsl
, gtk2
, libpng
, librsvg
, libGL
, libGLU
, python311
, sqlite
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

  python = python311.withPackages (ps: with ps; [
    numpy
    pillow
    pygobject3
    rdkit
    setuptools
  ]);

  boostWithPython = boost178.override {
    enablePython = true;
    python = python311;
  };

  rdkit = python311.pkgs.rdkit;
  pygobject3 = python311.pkgs.pygobject3;

  ccp4MonomerLibrary = fetchurl {
    name = "monomers-2023-01-02.tar.gz";
    url = "http://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/dependencies/monomers-2023-01-02-23:57:29.tar.gz";
    sha256 = "1kqmgxm849zv9blnmxi5yqgk08j8z570gpcv7aymsvvvhf1c2g8s";
  };
in
stdenv.mkDerivation rec {
  pname = "coot";
  version = "0.9.8.95";

  src = fetchFromGitHub {
    owner = "pemsley";
    repo = "coot";
    rev = "Release-${version}";
    hash = "sha256-eNOHHRjXMTjl1rp+WbsCxqlCfCVBY1htpM2tPBcoV6w=";
  };

  nativeBuildInputs = [
    autoreconfHook
    bc
    pkg-config
    makeWrapper
    python
    swig
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
    glib
    freeglut
    gnome2.gtkglext
    gnome2.libgnomecanvas
    goocanvas_2
    gsl
    gtk2
    libccp4
    libGL
    libGLU
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
    "--with-rdkit-prefix=${rdkit}"
    "--without-guile"
  ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail "AM_PATH_GTKGLEXT_1_0(1.0.0,,[exit 1])" \
        "PKG_CHECK_MODULES([GTKGLEXT], [gtkglext-1.0 >= 1.0.0])"

    substituteInPlace configure.ac \
      --replace-fail "AM_PATH_GLUT(, [echo You need the GLUT utility library; exit 1], AC_MSG_ERROR([Cannot find proper GLUT version]))" \
        "PKG_CHECK_MODULES([GLUT], [glut])
GLUT_LIBS=\"\$GLUT_LIBS -lGLU\""

    substituteInPlace configure.ac \
      --replace-fail " -lRDKitcoordgenlib" "" \
      --replace-fail " -lRDKitmaeparser" ""

    substituteInPlace configure.ac \
      --replace-fail '-lboost_serialization -l$BOOST_PYTHON_LIB $PYTHON_LIBS' \
        '-lboost_serialization -l$BOOST_PYTHON_LIB $PYTHON_LDFLAGS $PYTHON_EXTRA_LDFLAGS $PYTHON_EXTRA_LIBS'

    substituteInPlace configure.ac \
      --replace-fail '-std=c++11' '-std=c++14'

    substituteInPlace macros/ax_python_devel.m4 \
      --replace-fail "os.name <> 'nt'" "os.name != 'nt'"

    substituteInPlace src/cc-interface.hh \
      --replace-fail "#ifdef USE_PYTHON" "#if defined(USE_PYTHON) || defined(HAVE_PYTHON)"

    substituteInPlace src/callbacks.c \
      --replace-fail 'add_on_rama_choices("");' 'add_on_rama_choices();'

    substituteInPlace src/c-interface-validate.cc \
      --replace-fail '#include "coot-utils/peak-search.hh"' '#include "coot-utils/peak-search.hh"
#include "coot-utils/atom-overlaps.hh"'

    substituteInPlace src/nsv.cc \
      --replace-fail '   current_highlight_residue = 0;' '   #ifdef HAVE_GOOCANVAS
   current_highlight_residue = 0;
   #endif' \
      --replace-fail 'GCALLBACK(rect_event)' 'G_CALLBACK(rect_event)' \
      --replace-fail 'exptl::nsv::spec_and_object spec_obj_p = static_cast<exptl::nsv::spec_and_object *>(data);' \
        'exptl::nsv::spec_and_object *spec_obj_p = static_cast<exptl::nsv::spec_and_object *>(data);'

    substituteInPlace src/dynarama-main.cc \
      --replace-fail '#endif

#ifdef HAVE_GOOCANVAS' '#endif

#include <iostream>

#ifdef HAVE_GOOCANVAS'

    substituteInPlace coot-utils/Makefile.am \
      --replace-fail 'mmrrcc_LDADD = ./libcoot-map-utils.la \
	./libcoot-coord-utils.la  \
	$(top_builddir)/geometry/libcoot-geometry.la \
	$(top_builddir)/utils/libcoot-utils.la \
	$(top_builddir)/lidia-core/libcoot-lidia-core.la \
	$(CLIPPER_LIBS)' 'mmrrcc_LDADD = ./libcoot-map-utils.la \
	./libcoot-coord-utils.la  \
	$(top_builddir)/geometry/libcoot-geometry.la \
	$(top_builddir)/utils/libcoot-utils.la \
	$(top_builddir)/lidia-core/libcoot-lidia-core.la \
	$(CLIPPER_LIBS) $(RDKIT_LIBS) $(BOOST_LDFLAGS) $(L_BOOST_PYTHON) $(PYTHON_LIBS)'
  '';

  postInstall = ''
    mkdir -p "$out/share/coot/lib/data"
    tar xzf ${ccp4MonomerLibrary} -C "$out/share/coot/lib/data"

    for program in coot pyrogen; do
      if [ -x "$out/bin/$program" ]; then
        wrapProgram "$out/bin/$program" \
          --set COOT_REFMAC_LIB_DIR "$out/share/coot/lib" \
          --set CLIBD_MON "$out/share/coot/lib/data/monomers" \
          --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH" \
          --prefix PYTHONPATH : "$PYTHONPATH:$out/lib/python${python311.pythonVersion}/site-packages:$out/lib/python${python311.pythonVersion}/site-packages/coot"
      fi
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
