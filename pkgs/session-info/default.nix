{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  stdlib-list,
}:

buildPythonPackage rec {
  pname = "session-info";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "session_info";
    inherit version;
    hash = "sha256-1xlQ1ajOf399XoaqIIwUjE5QtUQLd9VUTUIrSOTz7UE=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    stdlib-list
  ];

  pythonImportsCheck = [
    "session_info"
  ];

  meta = {
    description = "Outputs version information for modules loaded in the current session, the OS, and the CPU";
    homepage = "https://github.com/joelostblom/session_info";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ];
  };
}
