{ lib
, stdenv
, requireFile
, autoPatchelfHook
, makeWrapper
, patchelf
, bash
, bzip2
, expat
, fontconfig
, freetype
, glib
, libGL
, libGLU
, libffi
, libgcrypt
, libidn
, libuuid
, libxcrypt-legacy
, libxml2
, ncurses
, openssl
, readline
, stdenvNoCC
, xorg
, zlib
}:

let
  runtimeLibs = [
    bzip2
    expat
    fontconfig
    freetype
    glib
    libGL
    libGLU
    libffi
    libgcrypt
    libidn.out
    libuuid
    libxcrypt-legacy
    libxml2
    ncurses
    openssl
    readline
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
    xorg.libXrandr
    xorg.libXrender
    xorg.libXt
    xorg.libXtst
    xorg.libxcb
    zlib
  ];
in
stdenvNoCC.mkDerivation rec {
  pname = "phenix";
  version = "2.1-6048";

  src = requireFile {
    name = "Phenix-${version}-Linux-x86_64.sh";
    sha256 = "sha256-okVeKB8RJB3r2yXZeIragzdCC5/0ySk1+XFX8Mybl5U=";
    message = ''
      Phenix is not fetched automatically. Add the non-CUDA Linux installer to
      the Nix store first:

        nix-store --add-fixed sha256 Phenix-${version}-Linux-x86_64.sh
    '';
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    patchelf
  ];

  buildInputs = runtimeLibs;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  autoPatchelfIgnoreMissingDeps = [
    "libidn.so.11"
    "libwebkitgtk-1.0.so.0"
  ];

  installPhase = ''
    runHook preInstall

    cp "$src" installer.sh
    chmod +w installer.sh
    sed -i '/chmod +x "\$CONDA_EXEC"/a patchelf --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" --set-rpath "${lib.makeLibraryPath runtimeLibs}" "$CONDA_EXEC"' installer.sh

    mkdir -p "$out/opt"
    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    ${bash}/bin/bash installer.sh -b -s -p "$out/opt/phenix" -m
    patchelf --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath runtimeLibs}:$out/opt/phenix/lib" \
      "$out/opt/phenix/bin/python3.9"
    LD_LIBRARY_PATH="${lib.makeLibraryPath runtimeLibs}:$out/opt/phenix/lib" \
      "$out/opt/phenix/bin/python3.9" \
      "$out/opt/phenix/lib/python3.9/site-packages/mmtbx/command_line/rebuild_rotarama_cache.py"
    LD_LIBRARY_PATH="${lib.makeLibraryPath runtimeLibs}:$out/opt/phenix/lib" \
      "$out/opt/phenix/bin/python3.9" \
      "$out/opt/phenix/lib/python3.9/site-packages/mmtbx/command_line/rebuild_cablam_cache.py"
    touch "$out/opt/phenix/lib/python3.9/site-packages/chem_data/rotarama_data/NO_UPDATE"

    macro_cycle_real_space_py="$out/opt/phenix/lib/python3.9/site-packages/phenix/refinement/macro_cycle_real_space.py"
    substituteInPlace "$macro_cycle_real_space_py" \
      --replace-fail 'if(self.params.rotamers.restraints.sigma is Auto):' \
                     'if(self.params.rotamers.restraints.sigma is Auto or self.params.rotamers.restraints.sigma is None):'

    tutorials_py="$out/opt/phenix/lib/python3.9/site-packages/wxGUI2/Tutorials.py"
    substituteInPlace "$tutorials_py" \
      --replace-fail 'def copy_to_project_dir(source_file, example_dir, project_dir):
  path, file_name = os.path.split(source_file)' 'def _make_user_writable(path):
  if os.path.isdir(path):
    for root, dirs, files in os.walk(path):
      for name in dirs + files:
        chmod_path = os.path.join(root, name)
        os.chmod(chmod_path, os.stat(chmod_path).st_mode | 0o600)
    os.chmod(path, os.stat(path).st_mode | 0o700)
  else:
    os.chmod(path, os.stat(path).st_mode | 0o600)

def copy_to_project_dir(source_file, example_dir, project_dir):
  path, file_name = os.path.split(source_file)' \
      --replace-fail '    shutil.copytree(
        os.path.join(example_dir, source_file),
        os.path.join(project_dir, file_name))' '    shutil.copytree(
        os.path.join(example_dir, source_file),
        os.path.join(project_dir, file_name))
    _make_user_writable(os.path.join(project_dir, file_name))' \
      --replace-fail '    shutil.copy(source_file, os.path.join(project_dir, file_name))' '    destination_file = os.path.join(project_dir, file_name)
    shutil.copy(source_file, destination_file)
    _make_user_writable(destination_file)'

    mkdir -p "$out/bin"
    for executable in "$out"/opt/phenix/bin/*; do
      if [ -f "$executable" ] && [ -x "$executable" ]; then
        makeWrapper "$executable" "$out/bin/$(basename "$executable")" \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}:$out/opt/phenix/lib" \
          --prefix PATH : "$out/opt/phenix/bin"
      fi
    done

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    "$out/bin/phenix.python" -c "from mmtbx.rotamer.rotamer_eval import RotamerEval; from mmtbx.validation import cablam; RotamerEval(); cablam.fetch_peptide_expectations(); cablam.fetch_ca_expectations(); cablam.fetch_motif_contours()"
    "$out/bin/phenix.python" -c "from pathlib import Path; p=Path('$out/opt/phenix/lib/python3.9/site-packages/phenix/refinement/macro_cycle_real_space.py'); assert 'sigma is Auto or self.params.rotamers.restraints.sigma is None' in p.read_text()"

    runHook postInstallCheck
  '';

  meta = {
    description = "PHENIX crystallography suite, non-CUDA Linux binary distribution";
    homepage = "https://phenix-online.org/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "phenix";
    platforms = [ "x86_64-linux" ];
    maintainers = [ ];
  };
}
