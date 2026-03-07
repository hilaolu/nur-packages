{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  polars,
  pyarrow,
  pandas,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "gtfparse";
  version = "2.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n+pUgRzYf1l6EQpJ3BsbajMl/7fR827MYsMtFNPrlJM=";
  };

  build-system = [
    setuptools
    wheel
    setuptools-scm
  ];

  dependencies = [
    polars
    pyarrow
    pandas
  ];

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "polars>=0.20.2,<0.21.0" "polars" \
      --replace "pyarrow>=14.0.2,<14.1.0" "pyarrow"
  '';

  pythonImportsCheck = [
    "gtfparse"
  ];

  meta = {
    description = "GTF Parsing Tools for Python";
    homepage = "https://github.com/openvax/gtfparse";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
