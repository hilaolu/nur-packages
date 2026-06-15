{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  future,
  h5py,
  matplotlib,
  numpy,
  pandas,
  pillow,
  scikit-image,
  scikit-learn,
  scipy,
  torch-bin,
}:

buildPythonPackage rec {
  pname = "topaz-em";
  version = "0.2.5a";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "3dem";
    repo = "topaz";
    rev = "c8dd487cbf9d27139d0d430068033fb90dd9a393";
    hash = "sha256-YHpXf6XkwVGpNPlZSwzKbslfIGZpPU6u1CIqnOdQI9c=";
  };

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [
    future
    h5py
    matplotlib
    numpy
    pandas
    pillow
    scikit-image
    scikit-learn
    scipy
    torch-bin
  ];

  pythonImportsCheck = [
    "topaz"
    "torch"
  ];

  meta = {
    description = "Particle picking and denoising for cryo-electron microscopy";
    homepage = "https://github.com/3dem/topaz";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "topaz";
    platforms = lib.platforms.linux;
  };
}
