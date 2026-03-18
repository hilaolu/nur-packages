{
  lib,
  buildPythonPackage,
  fetchPypi,
  biothings_client,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mygene";
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5ynKu8KM9a+yIbyhq2N4g7N1yxo+LwZ1h+x59xr/2uo=";
  };

  build-system = [
    setuptools
  ];

  propagatedBuildInputs = [
    biothings_client
  ];

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Python Client for MyGene.Info services";
    homepage = "https://github.com/biothings/mygene.py";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
