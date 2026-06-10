{ lib
, stdenv
, requireFile
, dpkg
, autoPatchelfHook
, autoAddDriverRunpath
, makeWrapper
, alsa-lib
, atk
, bzip2
, cairo
, cups
, cudaPackages
, dbus
, expat
, ffmpeg
, fontconfig
, freetype
, gdk-pixbuf
, gfortran
, glib
, gtk3
, libdrm
, libffi
, libGL
, libGLU
, libglvnd
, libpulseaudio
, libuuid
, libxcrypt
, libxcrypt-legacy
, libxkbcommon
, mesa
, ncurses
, nspr
, nss
, openssl
, pango
, pcsclite
, speechd
, sqlite
, stdenvNoCC
, wayland
, xdg-utils
, xorg
, xz
, zlib
, zstd
}:

let
  bundledQtLibDir = "lib/ucsf-chimerax/lib/python3.11/site-packages/PyQt6/Qt6/lib";
  runtimeLibs = [
    alsa-lib
    atk
    bzip2
    cairo
    cups
    cudaPackages.cuda_nvrtc
    cudaPackages.libcufft
    dbus
    expat
    ffmpeg
    fontconfig
    freetype
    gdk-pixbuf
    gfortran.cc.lib
    glib
    gtk3
    libdrm
    libffi
    libGL
    libGLU
    libglvnd
    libpulseaudio
    libuuid
    libxcrypt
    libxcrypt-legacy
    libxkbcommon
    mesa
    ncurses
    nspr
    nss
    openssl
    pango
    pcsclite
    speechd
    sqlite
    stdenv.cc.cc.lib
    wayland
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
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
    xz
    zlib
    zstd
  ];
in
stdenvNoCC.mkDerivation rec {
  pname = "ucsf-chimerax";
  version = "1.11.1ubuntu24.04";

  src = requireFile {
    name = "${pname}_${version}_amd64.deb";
    sha256 = "sha256-Ac91hNgIC4mkvRIjg4mMDuhBuVebSYzZoQcAm7J/VNo=";
    message = ''
      This package is built from the UCSF ChimeraX Debian package, which is not
      fetched automatically. Add it to the Nix store first:

        nix-store --add-fixed sha256 ucsf-chimerax_1.11.1ubuntu24.04_amd64.deb
    '';
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    autoAddDriverRunpath
    cudaPackages.autoAddCudaCompatRunpath
    makeWrapper
  ];

  buildInputs = runtimeLibs;

  dontConfigure = true;
  dontBuild = true;

  autoPatchelfIgnoreMissingDeps = [
    "libQt63DAnimation.so.6"
    "libQt63DCore.so.6"
    "libQt63DExtras.so.6"
    "libQt63DInput.so.6"
    "libQt63DLogic.so.6"
    "libQt63DQuick.so.6"
    "libQt63DQuickScene2D.so.6"
    "libQt63DQuickScene3D.so.6"
    "libQt63DRender.so.6"
    "libQt6EglFsKmsGbmSupport.so.6"
    "libQt6EglFsKmsSupport.so.6"
    "libQt6QmlCompiler.so.6"
    "libQt6QmlCore.so.6"
    "libQt6QmlLocalStorage.so.6"
    "libQt6QmlNetwork.so.6"
    "libQt6QmlXmlListModel.so.6"
    "libQt6Quick3DParticleEffects.so.6"
    "libQt6QuickControls2FluentWinUI3StyleImpl.so.6"
    "libQt6Scxml.so.6"
    "libQt6WebView.so.6"
    "libQt6WebViewQuick.so.6"
    "libcuda.so.1"
    "libmimerapi.so"
    "libmysqlclient.so.21"
    "libodbc.so.2"
    "libpq.so.5"
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x "$src" root
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib" "$out/bin" "$out/share"
    cp -a root/usr/lib/ucsf-chimerax "$out/lib/"
    if [ -d root/usr/share ]; then
      cp -a root/usr/share/. "$out/share/"
    fi

    makeWrapper "$out/lib/ucsf-chimerax/bin/ChimeraX" "$out/bin/chimerax" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}:$out/lib/ucsf-chimerax/lib:$out/${bundledQtLibDir}" \
      --prefix PATH : "${lib.makeBinPath [ ffmpeg xdg-utils ]}" \
      --set CHIMERAX "$out/lib/ucsf-chimerax"

    ln -s "$out/bin/chimerax" "$out/bin/ChimeraX"

    runHook postInstall
  '';

  preFixup = ''
    addAutoPatchelfSearchPath "$out/${bundledQtLibDir}"
  '';

  meta = with lib; {
    description = "UCSF ChimeraX molecular visualization system with OpenGL GPU support";
    homepage = "https://www.cgl.ucsf.edu/chimerax/";
    license = licenses.unfree;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
