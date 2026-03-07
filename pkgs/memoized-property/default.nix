{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "memoized-property";
  version = "1.0.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-S+TQIJlEubm2eNrp1+MSJJ/i5vuL3JvaodpN4yTw/PU=";
  };

  # No dependencies
  doCheck = false;

  meta = {
    description = "A simple decorator for memoizing properties";
    homepage = "https://github.com/estebistec/python-memoized-property";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
