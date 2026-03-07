{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  pycurl,
  setuptools,
  tinydb,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "tuspy";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FWc06sXGGgRs/s1w8UEZ8FvpLM4ZjrWhqZpmRIK+24k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    pycurl
    tinydb
    aiohttp
  ];

  pythonImportsCheck = [ "tusclient" ];

  meta = {
    description = "A Python client for the tus resumable upload protocol";
    homepage = "https://github.com/tus/tus-py-client";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
