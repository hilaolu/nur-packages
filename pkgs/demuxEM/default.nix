{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  docopt,
  numpy,
  pandas,
  scipy,
  scikit-learn,
  seaborn,
  pegasusio,
}:

buildPythonPackage rec {
  pname = "demuxEM";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lilab-bcb";
    repo = "demuxEM";
    rev = version;
    sha256 = "03wnaj5b8javpp3hc2v92mxpsj7rxyjl3f2x91f5s6214ffd7fz3";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    docopt
    numpy
    pandas
    scipy
    scikit-learn
    seaborn
    pegasusio
  ];

  pythonImportsCheck = [ "demuxEM" ];

  meta = {
    description = "DemuxEM is the demultiplexing module of Pegasus";
    homepage = "https://github.com/lilab-bcb/demuxEM";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
