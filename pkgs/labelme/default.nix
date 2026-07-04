{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wrapQtAppsHook,
  gdown,
  imgviz,
  matplotlib,
  natsort,
  numpy,
  onnxruntime,
  pillow,
  pyqt5,
  pyyaml,
  qtpy,
  scikit-image,
  termcolor,
}:

buildPythonPackage rec {
  pname = "labelme";
  version = "5.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "wkentaro";
    repo = "labelme";
    rev = "v${version}";
    hash = "sha256-W5oeFDpG7sTZvwBu9UJAHzFDLUqVwKXsYH49Cir/KF8=";
  };

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    gdown
    imgviz
    matplotlib
    natsort
    numpy
    onnxruntime
    pillow
    pyqt5
    pyyaml
    qtpy
    scikit-image
    termcolor
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
