{
  lib,
  stdenv,
  stdenvNoCC,
  fetchurl,
  autoAddDriverRunpath,
  autoPatchelfHook,
  makeWrapper,
  bash,
  coreutils,
  dbus,
  file,
  fontconfig,
  freetype,
  glib,
  harfbuzz,
  jre,
  libGL,
  libkrb5,
  libxkbcommon,
  mariadb-connector-c,
  python3,
  sqlite,
  systemdLibs,
  tcsh,
  xvfb-run,
  xorg,
  zlib,
}:

let
  version = "5.1.12";
  installerName = "imod_${version}_RHEL8-64_CUDA12.0.sh";
  runtimeLibs = [
    dbus
    fontconfig
    freetype
    glib
    harfbuzz
    libGL
    libkrb5
    libxkbcommon
    mariadb-connector-c
    sqlite
    stdenv.cc.cc.lib
    systemdLibs
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libXau
    xorg.libXext
    xorg.libxcb
    xorg.xcbutilimage
    xorg.xcbutilrenderutil
    zlib
  ];
  runtimePrograms = [
    bash
    coreutils
    file
    jre
    python3
    tcsh
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "imod";
  inherit version;

  src = fetchurl {
    name = installerName;
    url = "https://bio3d.colorado.edu/imod/AMD64-RHEL5/${installerName}";
    hash = "sha256-HLMAE8dPNKMzE5CcuvKT+1D7B/o8/3Hy3sUte5SMTak=";

    # The server currently omits an intermediate certificate. The fixed-output
    # hash still verifies the downloaded installer.
    curlOptsList = [ "--insecure" ];
  };

  nativeBuildInputs = [
    autoAddDriverRunpath
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = runtimeLibs;

  nativeInstallCheckInputs = [ xvfb-run ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack

    cp "$src" ${installerName}
    chmod +x ${installerName}
    ./${installerName} -extract
    tar -xzf IMODtempDir/imod_${finalAttrs.version}_RHEL8-64_CUDA12.0.tar.gz
    cd imod_${finalAttrs.version}

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt" "$out/bin"
    cp -a . "$out/opt/imod"

    patchShebangs --host "$out/opt/imod/bin"

    for executable in "$out"/opt/imod/bin/*; do
      if [ -f "$executable" ] && [ -x "$executable" ]; then
        makeWrapper "$executable" "$out/bin/$(basename "$executable")" \
          --set IMOD_DIR "$out/opt/imod" \
          --set IMOD_JAVADIR "${jre}" \
          --set IMOD_PLUGIN_DIR "$out/opt/imod/lib/imodplug" \
          --set IMOD_QTLIBDIR "$out/opt/imod/qtlib" \
          --set FOR_DISABLE_STACK_TRACE 1 \
          --prefix LD_LIBRARY_PATH : "$out/opt/imod/qtlib:$out/opt/imod/lib:${lib.makeLibraryPath runtimeLibs}" \
          --prefix PATH : "$out/opt/imod/bin:${lib.makeBinPath runtimePrograms}"
      fi
    done

    runHook postInstall
  '';

  preFixup = ''
    addAutoPatchelfSearchPath "${mariadb-connector-c}/lib/mariadb"
    addAutoPatchelfSearchPath "$out/opt/imod/lib"
    addAutoPatchelfSearchPath "$out/opt/imod/qtlib"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"

    if helpOutput="$(xvfb-run -a "$out/bin/imod" -h 2>&1)"; then
      helpStatus=0
    else
      helpStatus=$?
    fi

    printf '%s\n' "$helpOutput"
    test "$helpStatus" -eq 1
    grep -F "Usage: 3dmod" <<< "$helpOutput"

    runHook postInstallCheck
  '';

  meta = {
    description = "IMOD electron microscopy image-processing and modeling suite";
    homepage = "https://bio3d.colorado.edu/imod/";
    license = lib.licenses.gpl2Only;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "imod";
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
})
