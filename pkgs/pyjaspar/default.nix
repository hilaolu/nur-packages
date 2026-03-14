{
  lib,
  buildPythonPackage,
  fetchPypi,
  biopython,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pyjaspar";
  version = "4.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sxiTsHkXcMBE8re0JNiavnzKbWmP6YRnvBzSdqeizZA=";
  };

  build-system = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    biopython
  ];

  # Tests require network access or complex setup
  doCheck = false;

  meta = {
    description = "A serverless interface to the JASPAR database via Biopython and SQLite3";
    homepage = "https://github.com/asntech/pyjaspar";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
}
