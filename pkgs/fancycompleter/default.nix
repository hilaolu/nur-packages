{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, setupmeta
, pyrepl
, pyreadline ? null
, stdenv
}:

buildPythonPackage rec {
  pname = "fancycompleter";
  version = "0.9.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wkj4h01pxa8prv59zl09a0i3w26k835bfpjgvyvsai4mswgxq09";
  };

  nativeBuildInputs = [
    setuptools
    setupmeta
  ];

  propagatedBuildInputs = [
    pyrepl
  ] ++ lib.optionals stdenv.isCygwin [
    pyreadline
  ];

  doCheck = false;

  meta = with lib; {
    description = "Colorful TAB completion for Python prompt";
    homepage = "https://github.com/pdbpp/fancycompleter";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
