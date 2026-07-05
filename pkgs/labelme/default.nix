{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  hatch-fancy-pypi-readme,
  wrapQtAppsHook,
  imgviz,
  loguru,
  matplotlib,
  natsort,
  numpy,
  osam,
  pillow,
  pyqt5,
  pyyaml,
  scikit-image,
  scipy,
  tifffile,
}:

buildPythonPackage rec {
  pname = "labelme";
  version = "6.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wkentaro";
    repo = "labelme";
    rev = "v${version}";
    hash = "sha256-Gv9nE8sLBIJiu065kVgiInY3ByfvkudLV3D6Umvhns0=";
  };

  build-system = [
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    imgviz
    loguru
    matplotlib
    natsort
    numpy
    osam
    pillow
    pyqt5
    pyyaml
    scikit-image
    scipy
    tifffile
  ];

  pythonRemoveDeps = [
    "pyqt5-qt5"
  ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  pythonImportsCheck = [ "labelme" ];

  meta = {
    description = "Image polygonal annotation with Python";
    homepage = "https://github.com/wkentaro/labelme";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "labelme";
  };
}
