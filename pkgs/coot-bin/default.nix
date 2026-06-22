{ lib
, stdenvNoCC
, fetchurl
, autoPatchelfHook
, makeWrapper
, alsa-lib
, atk
, blas
, bash
, bzip2
, cairo
, expat
, fontconfig
, freetype
, gdk-pixbuf
, glib
, gtk2
, icu63
, lapack
, libGL
, libGLU
, libXft
, libffi
, libjpeg8
, libpng
, libxcrypt-legacy
, libxml2
, ncurses
, openssl_1_1
, pango
, stdenv
, xorg
, zlib
}:

let
  runtimeLibs = [
    alsa-lib
    atk
    blas
    bzip2
    cairo
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk2
    icu63
    lapack
    libGL
    libGLU
    libXft
    libffi
    libjpeg8
    libpng
    libxcrypt-legacy
    libxml2
    ncurses
    openssl_1_1
    pango
    stdenv.cc.cc.lib
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXau
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXdmcp
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXmu
    xorg.libXpm
    xorg.libXrandr
    xorg.libXrender
    xorg.libXt
    xorg.libXtst
    xorg.libxcb
    zlib
  ];
in
stdenvNoCC.mkDerivation rec {
  pname = "coot-bin";
  version = "0.9.8";

  src = fetchurl {
    url = "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/binaries/release/coot-${version}-binary-Linux-x86_64-ubuntu-20.04.4-python-gtk2.tar.gz";
    hash = "sha256-V9H0nfO/ItXfLhu34ZZvDoTl8/DS/NXHvItb8FKTNts=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = runtimeLibs;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt" "$out/bin"
    cp -a . "$out/opt/coot-bin"

    ln -s "$out/opt/coot-bin/lib/python2.7" "$out/opt/coot-bin/python27"
    patchShebangs "$out/opt/coot-bin/bin"

    for program in coot findligand findwaters lidia; do
      makeWrapper "$out/opt/coot-bin/bin/$program" "$out/bin/$program" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}:$out/opt/coot-bin/lib" \
        --prefix PATH : "$out/opt/coot-bin/bin" \
        --set COOT_PREFIX "$out/opt/coot-bin" \
        --set COOT_REFMAC_LIB_DIR "$out/opt/coot-bin/share/coot/lib" \
        --set CLIBD_MON "$out/opt/coot-bin/share/coot/lib/data/monomers"
    done

    runHook postInstall
  '';

  preFixup = ''
    addAutoPatchelfSearchPath "$out/opt/coot-bin/lib"
  '';

  meta = {
    description = "Macromolecular crystallography model-building toolkit, binary distribution";
    homepage = "https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "coot";
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
