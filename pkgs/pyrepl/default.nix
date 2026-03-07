{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setuptools-scm
, setupmeta
, pytest
, pytest-cov
, pytest-timeout
, pexpect
}:

buildPythonPackage rec {
  pname = "pyrepl";
  version = "0.11.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qvhrzbrlnz8bscpfp9gxkzbdhpfk8kc57bnx63xbvp5lss8isgg";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    setupmeta
  ];

  checkInputs = [
    pytest
    pytest-cov
    pytest-timeout
    pexpect
  ];

  meta = with lib; {
    description = "A library for building flexible command line interfaces";
    homepage = "https://github.com/bretello/pyrepl";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
