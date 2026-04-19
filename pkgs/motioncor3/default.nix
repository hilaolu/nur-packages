{ lib
, fetchFromGitHub
, cudaPackages
, libtiff
, autoAddDriverRunpath
}:

let
  stdenv = cudaPackages.backendStdenv;
in
stdenv.mkDerivation rec {
  pname = "motioncor3";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "czimaginginstitute";
    repo = "MotionCor3";
    rev = "dd8b6831ae66ef016fb7ef3b9b6172f8b56c79aa";
    hash = "sha256-D6VSCBNgp/WMSj96pFDh9tX9Zslec0JNzmrA4R+o2DU=";
  };

  nativeBuildInputs = [
    cudaPackages.cuda_nvcc
    cudaPackages.setupCudaHook
    autoAddDriverRunpath
    cudaPackages.autoAddCudaCompatRunpath
  ];

  buildInputs = [
    cudaPackages.cuda_cudart
    cudaPackages.libcufft
    cudaPackages.cuda_nvtx
    cudaPackages.libcurand
    cudaPackages.libcublas
    libtiff
  ];

  postPatch = ''
    # Remove hardcoded paths and conda references
    sed -i '/^CONDA =/d' makefile11
    sed -i '/^CUDAHOME =/d' makefile11
    sed -i '/^CUDAINC =/d' makefile11
    sed -i '/^CUDALIB =/d' makefile11

    # Fix the rule for .cu files to include CUDAINC
    substituteInPlace makefile11 \
      --replace-fail "\$(CUFLAG) -I\$(PRJINC)" "\$(CUFLAG) -I\$(PRJINC) \$(CUDAINC)" \
      --replace-fail "-I\$(CONDA)/include" "" \
      --replace-fail "-L\$(CONDA)/lib" "" \
      --replace-fail "-L/usr/lib64" "" \
      --replace-fail "@\$(NVCC)" "\$(NVCC)" \
      --replace-fail "NVCC = \$(CUDAHOME)/bin/nvcc" "NVCC = nvcc" \
      --replace-fail "-std=c++11" "-std=c++17"

    # Fix LibSrc Makefiles to use provided CC
    substituteInPlace LibSrc/Mrcfile/makefile \
      --replace-fail "CC = g++" "CC ?= g++" \
      --replace-fail "-std=c++11" "-std=c++17"
    substituteInPlace LibSrc/Util/makefile \
      --replace-fail "CC = g++" "CC ?= g++" \
      --replace-fail "-std=c++11" "-std=c++17"
      
    # Patch makefile to not add -L to CUDALIB
    sed -i 's/-L\$(CUDALIB)/\$(CUDALIB)/g' makefile11
  '';

  buildPhase = ''
    runHook preBuild

    # Create directories expected by internal Makefiles
    mkdir -p LibSrc/Lib LibSrc/Include/Mrcfile LibSrc/Include/Util

    # Build internal libs
    make -C LibSrc/Mrcfile CC="$CXX"
    make -C LibSrc/Util CC="$CXX"

    # Extract include paths for nvcc
    export CUDAINC=""
    for flag in $NIX_CFLAGS_COMPILE; do
      if [[ $flag == -I* ]]; then
        CUDAINC="$CUDAINC $flag"
      fi
    done
    # Handle -isystem
    CUDAINC="$CUDAINC $(echo $NIX_CFLAGS_COMPILE | sed 's/-isystem \([^ ]*\)/-I\1/g' | tr ' ' '\n' | grep '^-I' | tr '\n' ' ')"

    # Extract library paths for linking
    export CUDALIB=""
    for flag in $NIX_LDFLAGS; do
      if [[ $flag == -L* ]]; then
        CUDALIB="$CUDALIB $flag"
      fi
    done
    # Add CUDA stubs for libcuda.so during linking
    CUDALIB="$CUDALIB -L${cudaPackages.cuda_cudart}/lib/stubs"

    # Build main executable
    make -f makefile11 exe \
      CC="$CXX" \
      NVCC="nvcc -ccbin $CC" \
      CUDAINC="$CUDAINC" \
      CUDALIB="$CUDALIB" \
      PRJHOME=$(pwd)

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 MotionCor3 $out/bin/MotionCor3
    runHook postInstall
  '';

  postFixup = ''
    # Remove the stub path from RUNPATH to avoid using it at runtime
    # We use patchelf to filter the RUNPATH
    old_rpath=$(patchelf --print-rpath $out/bin/MotionCor3)
    new_rpath=$(echo "$old_rpath" | sed "s|:${cudaPackages.cuda_cudart}/lib/stubs||g; s|${cudaPackages.cuda_cudart}/lib/stubs:||g; s|${cudaPackages.cuda_cudart}/lib/stubs||g")
    patchelf --set-rpath "$new_rpath" $out/bin/MotionCor3
  '';

  meta = with lib; {
    description = "GPU-accelerated beam-induced motion correction for cryo-EM";
    homepage = "https://github.com/czimaginginstitute/MotionCor3";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
