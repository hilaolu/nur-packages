{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnet-sdk_10
}:

buildDotnetModule rec {
  pname = "office-cli";
  version = "1.0.60";

  src = fetchFromGitHub {
    owner = "iOfficeAI";
    repo = "OfficeCLI";
    rev = "v${version}";
    hash = "sha256-vQ7yWbEgeS1L4QmCsYFjtYiqtTAK5tGK38mqld9TOs8=";
  };

  projectFile = "src/officecli/officecli.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnet-sdk_10;

  meta = with lib; {
    description = "CLI tool for AI agents to interact with Microsoft Office files";
    homepage = "https://github.com/iOfficeAI/OfficeCLI";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "officecli";
  };
}
