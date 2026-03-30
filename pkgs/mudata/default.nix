{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-vcs,
  anndata,
  h5py,
  numpy,
  pandas,
  scipy,
  scverse-misc,
  session-info2,
}:

buildPythonPackage rec {
  pname = "mudata";
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CsvXw8Zo/V/R4XwuM7yf0X3xLOpepC3JuJhq0QQZWl0=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    anndata
    h5py
    numpy
    pandas
    scipy
    scverse-misc
    session-info2
  ];

  doCheck = false;

  pythonImportsCheck = [
    "mudata"
  ];

  meta = {
    description = "Multimodal data format for Python";
    homepage = "https://github.com/scverse/mudata";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
