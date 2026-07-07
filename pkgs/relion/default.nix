{ lib
, stdenv
, fetchFromGitHub
, cudaPackages
, cmake
, pkg-config
, makeWrapper
, autoAddDriverRunpath
, expat
, fftw
, fftwFloat
, fltk
, ghostscript
, libjpeg
, libpng
, libtiff
, libx11
, libxext
, libxfixes
, libxft
, libxinerama
, openmpi
, pbzip2
, python3
, vulkan-loader
, xz
, zlib
, zstd
}:

let
  cudaStdenv = cudaPackages.backendStdenv;
  pythonWithTk = python3.withPackages (ps: [
    ps.tkinter
  ]);
  relionScriptDirectory = "$out/share/relion/scripts";
  runtimeLibraryPath = lib.makeLibraryPath [
    vulkan-loader
  ];
in
cudaStdenv.mkDerivation rec {
  pname = "relion";
  version = "ver5.1";

  src = fetchFromGitHub {
    owner = "hilaolu";
    repo = "relion";
    rev = version;
    hash = "sha256-Bm0ZgXxv803kwUNXbMEXCjGrPlmkmXdvBydyt6VF2Gk=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    cudaPackages.cuda_nvcc
    cudaPackages.setupCudaHook
    autoAddDriverRunpath
    cudaPackages.autoAddCudaCompatRunpath
  ];

  buildInputs = [
    cudaPackages.cuda_cccl
    cudaPackages.cuda_cudart
    cudaPackages.libcufft
    cudaPackages.libcurand
    expat
    fftw
    fftwFloat
    fltk
    libjpeg
    libpng
    libtiff
    openmpi
    pythonWithTk
    vulkan-loader
    libx11
    libxext
    libxfixes
    libxft
    libxinerama
    zlib
  ];

  propagatedUserEnvPkgs = [
    openmpi
  ];

  cmakeFlags = [
    "-DCUDA=ON"
    "-DCMAKE_CUDA_HOST_COMPILER=${cudaStdenv.cc}/bin/cc"
    "-DCUDA_ARCH=50"
    "-DFETCH_WEIGHTS=OFF"
    "-DFORCE_OWN_FFTW=OFF"
    "-DFORCE_OWN_FLTK=OFF"
    "-DGUI=ON"
    "-DPYTHON_EXE_PATH=${pythonWithTk}/bin/python3"
  ];

  postPatch = ''
    substituteInPlace src/time.cpp \
      --replace-fail "fprintf(stdout, cheese);" "fprintf(stdout, \"%s\", cheese);"
  '';

  preConfigure = ''
    mkdir -p "$NIX_BUILD_TOP/torch-home"
    cmakeFlagsArray+=("-DTORCH_HOME_PATH=$NIX_BUILD_TOP/torch-home")
    export FFTW_INCLUDE="${fftw.dev}/include"
    export FFTW_LIB="${fftw}/lib;${fftwFloat}/lib"
  '';

  postInstall = ''
    substituteInPlace $out/bin/relion_qsub.csh \
      --replace-fail "mpiexec -mca orte_forward_job_control 1 -n XXXmpinodesXXX" \
                     "${openmpi}/bin/mpirun -n XXXmpinodesXXX"

    install -D -d ${relionScriptDirectory}
    cp -R ${src}/scripts/Schemes ${relionScriptDirectory}/

    wrapProgram $out/bin/relion \
      --prefix PATH : $out/bin:${lib.makeBinPath [ ghostscript openmpi pbzip2 xz zstd ]} \
      --prefix LD_LIBRARY_PATH : ${runtimeLibraryPath} \
      --set RELION_MPIRUN ${openmpi}/bin/mpirun \
      --set RELION_QSUB_TEMPLATE $out/bin/relion_qsub.csh \
      --set RELION_SCRIPT_DIRECTORY ${relionScriptDirectory}

    if [ -x "$out/bin/relion_schemegui" ]; then
      PATH=${pythonWithTk}/bin:$PATH patchShebangs --host "$out/bin/relion_schemegui"
      wrapProgram $out/bin/relion_schemegui \
        --prefix PATH : ${lib.makeBinPath [ pythonWithTk ]} \
        --set RELION_SCRIPT_DIRECTORY ${relionScriptDirectory}
    fi

    if [ -x "$out/bin/relion_it.py" ]; then
      wrapProgram $out/bin/relion_it.py \
        --set RELION_SCRIPT_DIRECTORY ${relionScriptDirectory}
    fi
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    ${pythonWithTk}/bin/python3 -c "import tkinter; import _tkinter"

    if [ -x "$out/bin/relion_schemegui" ]; then
      grep -F "${pythonWithTk}/bin/python3" "$out/bin/.relion_schemegui-wrapped"
      grep -F "RELION_SCRIPT_DIRECTORY" "$out/bin/relion_schemegui"
      test -f "${relionScriptDirectory}/Schemes/amyprep/scheme.star"
    fi

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Program for Bayesian analysis of cryo-EM data with CUDA acceleration";
    homepage = "https://github.com/3dem/relion";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
