{ stdenv
, autoPatchelfHook
, bubblewrap
, makeWrapper
, makeDesktopItem
, writeShellScript
, glibc
, lib
, libXxf86vm
, libXtst
, xorg
, libGL
, glfw-wayland-minecraft
, openjdk21
, vulkan-loader
, ...
}:

let


  libPath = lib.makeLibraryPath [
   libXxf86vm
   libXtst
   libGL
   vulkan-loader
   xorg.libX11
   glfw-wayland-minecraft
   stdenv.cc.cc.lib
  ];



  startScript = writeShellScript "HMCL" ''

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
      --bind ~/.local/share/hmcl/ ~/.local/share/hmcl/
      --chdir ~/.local/share/hmcl/
      --dev-bind /dev /dev
      --die-with-parent
      --ro-bind /nix /nix
      --proc /proc
      --bind ${glibc}/lib /lib
      --bind ${glibc}/lib /lib64
      --bind ${glfw-wayland-minecraft}/lib /lib
      --bind /usr/bin/env /usr/bin/env
      --setenv LD_LIBRARY_PATH "${libPath}:''${LD_LIBRARY_PATH}"
      "''${auto_mounts[@]}"
      ${openjdk21}/bin/java -jar HMCL.jar 
    )
    exec "''${cmd[@]}"
  '';

  desktopFile = makeDesktopItem {
      name = "HMCL";
      desktopName = "HMCL";
      comment = "";
      exec = "${startScript}";
      startupNotify = false;
      startupWMClass = "HMCL";
  };


in

stdenv.mkDerivation {
  pname = "HMCL";
  version = "rolling";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin $out/share/applications
    ln -s ${startScript} $out/bin/HMCL
    ln -s ${desktopFile} $out/share/applications/HMCL.desktop
  '';
}
