{ stdenv
, autoPatchelfHook
, makeWrapper
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

stdenv.mkDerivation rec {
  pname = "foldit";
  version = "24";

  src = fetchurl {
    url = "https://files.ipd.uw.edu/pub/foldit/Foldit-linux_x64.tar.gz";
    sha256 = "30164ef90816fa6fed821ba2d0cb8a98e34b91f5cb0554bd822d04f2587d6054";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  libraries = [
   mesa
   libGL
   libGLU
   libglvnd
   freeglut 
   xorg.libX11
  ];

  buildInputs = libraries;

  unpackPhase = ''
    tar xf ${src}
  '';

  #preBuild = ''
    #addAutoPatchelfSearchPath $out/cmp-binary-*
  #'';

  installPhase = ''
    cp -r Foldit $out -T
    mkdir -p $out/bin

    makeWrapper $out/Foldit $out/bin/Foldit \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libraries}" \
      --run "cd $out"

  '';


}
