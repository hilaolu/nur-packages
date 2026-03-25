{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools-scm,
  loompy,
  h5py,
  docopt,
  natsort,
  numpy,
  pandas,
  scipy,
  zarr,
  pillow,
}:

buildPythonPackage rec {
  pname = "pegasusio";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilab-bcb";
    repo = "pegasusio";
    rev = version;
    sha256 = "1rpi9dw6mi57lbkf169gzxkz5b4290b92gghcwxb37sfz7x84xmv";
  };

  build-system = [
    cython
    setuptools-scm
  ];

  dependencies = [
    loompy
    h5py
    docopt
    natsort
    numpy
    pandas
    scipy
    zarr
    pillow
  ];

  pythonImportsCheck = [ "pegasusio" ];

  meta = {
    description = "A Python package for reading / writing single-cell genomics data";
    homepage = "https://github.com/lilab-bcb/pegasusio";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
