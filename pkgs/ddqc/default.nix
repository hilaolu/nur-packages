{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  matplotlib,
  pandas,
  pegasusio,
  pegasuspy,
  seaborn,
}:

  buildPythonPackage rec {
  pname = "ddqc";
  version = "1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ayshwaryas";
    repo = "ddqc";
    rev = "v${version}";
    sha256 = "113z4pkxll6mb9bwgqxz1l11l0plv8sjrkgqf6pq3b7margvgh1b";
  };

  build-system = [
    setuptools
  ];
  dependencies = [
    numpy
    matplotlib
    pandas
    pegasusio
    pegasuspy
    seaborn
  ];


  meta = {
    description = "Data-Driven Quality Control for Single-Cell RNA-Seq Data";
    homepage = "https://github.com/ayshwaryas/ddqc";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
