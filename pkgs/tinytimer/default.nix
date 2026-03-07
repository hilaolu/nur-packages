{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "tinytimer";
  version = "0.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-atE8jwGrYJTlgIGlNn/8TFgx8taykDTSQ02K4QYwj6U=";
  };

  # No dependencies
  doCheck = false; # No tests usually for such small packages, or need config

  meta = {
    description = "A tiny timer";
    homepage = "https://github.com/iskandr/tinytimer";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
