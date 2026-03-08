{
  buildRPackage,
  fetchFromGitHub,
}:

buildRPackage {
  name = "MRMix-0.1.0";
  src = fetchFromGitHub {
    owner = "gqi";
    repo = "MRMix";
    rev = "56afdb2bc96760842405396f5d3f02e60e305039";
    sha256 = "0ag4nscamzzf67aaciq8j6znll427d84w17b3gpq6x6rcvkn4g3f";
  };
}
