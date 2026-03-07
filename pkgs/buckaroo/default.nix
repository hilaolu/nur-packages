{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  anywidget,
  cloudpickle,
  fastparquet,
  graphlib-backport,
  polars,
  pyarrow,
}:

buildPythonPackage rec {
  pname = "buckaroo";
  version = "0.12.5";
  format = "wheel";

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-V0qshqjXcv8dZwMmzuYNOL2eRfUPzTwWOArJzuJMv8Y=";
  };

  dependencies = [
    anywidget
    cloudpickle
    fastparquet
    graphlib-backport
    polars
    pyarrow
  ];

  # No tests in wheel; tests require Jupyter kernel + browser
  doCheck = false;

  pythonImportsCheck = [ "buckaroo" ];

  meta = {
    description = "The Data Table for Jupyter - GUI Data wrangling for pandas";
    homepage = "https://github.com/buckaroo-data/buckaroo";
    changelog = "https://github.com/buckaroo-data/buckaroo/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
