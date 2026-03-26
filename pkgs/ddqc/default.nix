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
  version = "unstable-2023-05-22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ayshwaryas";
    repo = "ddqc";
    rev = "b09a71efe43688f38f35634d61acb2a48d0d1af8";
    sha256 = "077jqhhz2kwqma4sbvnmwd5sig8w4lw4d800zyhkdbmlb019mvnk";
  };

  build-system = [
    setuptools
  ];
  dependencies = [
    setuptools
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
