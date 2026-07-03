{ lib
, stdenvNoCC
, fetchurl
, autoPatchelfHook
, makeWrapper
, alsa-lib
, curl
, dbus
, expat
, fontconfig
, freetype
, glib
, icu
, krb5
, libGL
, libGLU
, libdrm
, libglvnd
, libssh
, libxkbcommon
, mesa
, openssl
, stdenv
, wayland
, xorg
, zlib
, zstd
}:

let
  runtimeLibs = [
    alsa-lib
    curl
    dbus
    expat
    fontconfig
    freetype
    glib
    icu
    krb5
    libGL
    libGLU
    libdrm
    libglvnd
    libssh
    libxkbcommon
    mesa
    openssl
    stdenv.cc.cc.lib
    wayland
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXau
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXdmcp
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
    xorg.libXrender
    xorg.libXt
    xorg.libXtst
    xorg.libxcb
    xorg.libxkbfile
    xorg.libxshmfence
    xorg.xcbutil
    xorg.xcbutilcursor
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    zlib
    zstd
  ];
in
stdenvNoCC.mkDerivation rec {
  pname = "itk-snap";
  version = "4.4.0";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/itk-snap/itk-snap/${version}/itksnap-${version}-20250909-Linux-x86_64.tar.gz";
    hash = "sha256-EFJMFD0ynBl6bOBawRLc1WhvnA1LO5hcIofALekjlIw=";
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
    cp -a . "$out/opt/itk-snap"

    for program in "$out"/opt/itk-snap/bin/*; do
      if [ -f "$program" ] && [ -x "$program" ]; then
        makeWrapper "$program" "$out/bin/$(basename "$program")" \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}:$out/opt/itk-snap/lib/snap-${version}"
      fi
    done

    runHook postInstall
  '';

  preFixup = ''
    addAutoPatchelfSearchPath "$out/opt/itk-snap/lib/snap-${version}"
  '';

  meta = {
    description = "Interactive medical image segmentation and visualization application";
    homepage = "https://www.itksnap.org/";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "itksnap";
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
