{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, aiobotocore
, aiohttp
, alembic
, boto3
, botocore
, fancycompleter
, s3fs
, sqlalchemy
, python-dateutil
, pyyaml
, requests
, rich
, textual
}:

buildPythonPackage rec {
  pname = "redun";
  version = "0.35.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yn4hp7vpqgdgm2wa4mmfsn5h57a2c1d2fn9xdim0av6nvchf1hp";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiobotocore
    aiohttp
    alembic
    boto3
    botocore
    fancycompleter
    s3fs
    sqlalchemy
    python-dateutil
    pyyaml
    requests
    rich
    textual
  ];

  doCheck = false;
  pythonImportsCheck = [ "redun" ];

  meta = with lib; {
    description = "Yet another redundant workflow engine";
    homepage = "https://github.com/insitro/redun";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
