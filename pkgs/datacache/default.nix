{
  lib,
  buildPythonPackage,
  fetchPypi,
  appdirs,
  progressbar33,
  requests,
}:

buildPythonPackage rec {
  pname = "datacache";
  version = "1.4.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rP29xVDH4JcbQuwFdc7CJF7ErOHN+56TGFLbFX5bbGc=";
  };

  propagatedBuildInputs = [
    appdirs
    progressbar33
    requests
  ];

  doCheck = false;

  meta = {
    description = "Helpers for transparently downloading datasets";
    homepage = "https://github.com/openvax/datacache";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
  };
}
