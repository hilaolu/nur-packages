{
  lib,
  buildPythonPackage,
  fetchPypi,
  httpx,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "biothings_client";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WzTgnJBSgLW9JTjx80tvx4DFPI2ptAdOP/MEg2BG9hM=";
  };

  build-system = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    httpx
  ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Python Client for BioThings API services";
    homepage = "https://github.com/biothings/biothings_client.py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
