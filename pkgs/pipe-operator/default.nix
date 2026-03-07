{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  typing-extensions,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "pipe-operator";
  version = "2.0.1-unstable-2026-01-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hilaolu";
    repo = "pipe-operator";
    rev = "2a103630f7937d9f1cb639cfee75be8a910a7eaf";
    hash = "sha256-8lQ7sWCm1HoJFyWcgVYlpJI7tPz1zMtsKmzW15Bm9lE=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    typing-extensions
  ];

  pythonImportsCheck = [
    "pipe_operator"
  ];

  meta = {
    description = "Elixir's pipe operator in Python";
    homepage = "https://github.com/hilaolu/pipe-operator";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
