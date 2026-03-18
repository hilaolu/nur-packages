{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  numpy,
  pandas,
  scikit-learn,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "harmonypy";
  version = "0.0.9"; # Version in __init__.py of f6ac32e
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slowkow";
    repo = "harmonypy";
    rev = "f6ac32e";
    hash = "sha256-VdRcyW9kEz/WQHZZwv0XSbwd4PKeElfk4q2smJk+UhI=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    numpy
    pandas
    scikit-learn
    scipy
  ];

  # Tests are not standard pytest tests and seem to require manual fixture setup
  # or are designed for the __main__ block in test_harmony.py
  doCheck = false;

  pythonImportsCheck = [
    "harmonypy"
  ];

  meta = {
    description = "A data integration algorithm";
    homepage = "https://github.com/slowkow/harmonypy";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
  };
}
