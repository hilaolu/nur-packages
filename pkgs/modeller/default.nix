{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  glib,
  python3,
  zlib,
}:

let
  executableType =
    {
      "aarch64-linux" = "armv8-gnu";
      "armv7l-linux" = "armv6l-gnu";
      "i686-linux" = "i386-intel8";
      "x86_64-linux" = "x86_64-intel8";
    }
    .${stdenv.hostPlatform.system};
in
stdenv.mkDerivation rec {
  pname = "modeller";
  version = "10.8";

  src = fetchurl {
    url = "https://salilab.org/modeller/${version}/modeller-${version}.tar.gz";
    hash = "sha256-3emdytjilF1I+dh+ohrd+tkPYa3hS716etOLclMMWSc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    glib
    zlib
  ];

  nativeCheckInputs = [
    python3
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib"
    cp -a ChangeLog INSTALLATION README doc examples modlib src "$out/"
    cp -a bin/*.top bin/lib "$out/bin/"
    cp -a "bin/mod${version}_${executableType}" "$out/bin/"
    cp -a "lib/${executableType}" "$out/lib/"

    sed \
      -e "s;EXECUTABLE_TYPE10v8=xxx;EXECUTABLE_TYPE10v8=${executableType};" \
      -e "s;MODINSTALL10v8=xxx;MODINSTALL10v8=\"$out\";" \
      bin/modscript > "$out/bin/mod${version}"
    sed \
      -e "s;@TOPDIR@;\"$out\";" \
      -e "s;@EXETYPE@;${executableType};" \
      bin/modpy.sh.in > "$out/bin/modpy.sh"
    chmod +x "$out/bin/mod${version}" "$out/bin/modpy.sh"

    # Read the license at runtime so that it never becomes part of the Nix
    # store. Users can obtain a key from the academic license server and set
    # it with KEY_MODELLER before invoking Modeller.
    printf '%s\n' \
      'import os' \
      "install_dir = r'$out'" \
      'license = os.environ.get("KEY_MODELLER", "")' \
      > "$out/modlib/modeller/config.py"

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    test -x "$out/bin/mod${version}"
    test -x "$out/bin/modpy.sh"
    "$out/bin/modpy.sh" ${python3}/bin/python3 -c \
      "import sys; sys.path.insert(0, '$out/lib/${executableType}/python3.3'); import _modeller"
    grep -F "install_dir = r'$out'" "$out/modlib/modeller/config.py"
    grep -F "KEY_MODELLER" "$out/modlib/modeller/config.py"

    runHook postInstallCheck
  '';

  meta = {
    description = "Comparative protein structure modeling software";
    longDescription = ''
      MODELLER performs comparative protein structure modeling by satisfaction
      of spatial restraints. A license key is required at runtime; obtain one
      from the MODELLER registration page and export it as KEY_MODELLER.
    '';
    homepage = "https://salilab.org/modeller/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "mod${version}";
    platforms = [
      "aarch64-linux"
      "armv7l-linux"
      "i686-linux"
      "x86_64-linux"
    ];
    maintainers = [ ];
  };
}
