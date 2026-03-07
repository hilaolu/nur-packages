{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  cython,
  zlib,
  urllib3,
}:

buildPythonPackage rec {
  pname = "liftover";
  version = "1.1.16";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/ByS7zJ5thosz9jDzbnLSCmxGg+TVtFQl8YR/ABk/Q8=";
  };

  build-system = [
    setuptools
    wheel
    cython
  ];

  buildInputs = [
    zlib
  ];

  dependencies = [
    cython
    urllib3
    setuptools
  ];

  pythonImportsCheck = [
    "liftover"
  ];

  meta = {
    description = "Genomic coordinate conversion";
    homepage = "https://github.com/jeremymcrae/liftover";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
