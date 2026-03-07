{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  tuspy,
  setuptools,
  pyyaml,
  requests-toolbelt,
}:

buildPythonPackage rec {
  pname = "bioblend";
  version = "1.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bnd+1LwjniexYYoZPD977KSunpoU7PHG4RWTFIhGZVg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    tuspy
    pyyaml
    requests-toolbelt
  ];

  # Tests require a running Galaxy instance
  doCheck = false;

  pythonImportsCheck = [ "bioblend" ];

  meta = {
    description = "CloudMan and Galaxy API library";
    homepage = "https://bioblend.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
