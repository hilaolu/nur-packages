{ stdenv
, autoPatchelfHook
, bubblewrap
, makeWrapper
, makeDesktopItem
, writeShellScript
, glibc
, lib
, libGL
, libGLU
, libglvnd
, fetchurl
, freeglut
, mesa
, xorg
, ...
}:

let


  libPath = lib.makeLibraryPath [
   mesa
   libGLU
   libGL
   freeglut 
   xorg.libX11
   stdenv.cc.cc.lib
  ];



  startScript = writeShellScript "Foldit" ''

  blacklist=(/nix /dev /usr /lib /lib64 /proc)

  declare -a auto_mounts
  for dir in /*; do
      # if it is a directory and it is not in the blacklist
      if [[ -d "$dir" ]] && [[ ! "''${blacklist[@]}" =~ "$dir" ]]; then
      # add it to the mount list
      auto_mounts+=(--bind "$dir" "$dir")
      fi
  done

  cmd=(
      ${bubblewrap}/bin/bwrap
      --bind ~/.local/share/Foldit/ ~/.local/share/Foldit/
      --chdir ~/.local/share/Foldit/
      --dev-bind /dev /dev
      --die-with-parent
      --ro-bind /nix /nix
      --proc /proc
      --bind ${glibc}/lib /lib
      --bind ${glibc}/lib /lib64
      --bind /usr/bin/env /usr/bin/env
      --setenv LD_LIBRARY_PATH "${libPath}:''${LD_LIBRARY_PATH}"
      "''${auto_mounts[@]}"
      ./Foldit 
    )
    exec "''${cmd[@]}"
  '';

  desktopFile = makeDesktopItem {
      name = "Foldit";
      desktopName = "Foldit";
      comment = "Protein Folding Game";
      exec = "${startScript}";
      startupNotify = false;
      startupWMClass = "Foldit";
  };


in

stdenv.mkDerivation {
  pname = "Foldit";
  version = "rolling";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    ln -s ${startScript} $out/bin/Foldit
    ln -s ${desktopFile} $out/share/applications/Foldit.desktop
  '';
}
