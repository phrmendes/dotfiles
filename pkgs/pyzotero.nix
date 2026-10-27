{ python314Packages, src }:

python314Packages.pyzotero.overridePythonAttrs (_: {
  version = "1.16.0";

  format = "wheel";
  pyproject = null;

  src = builtins.path {
    path = src;
    name = "pyzotero-1.16.0-py3-none-any.whl";
  };

  postPatch = "";

  doCheck = false;

  dependencies = with python314Packages; [
    bibtexparser
    feedparser
    httpx2
    whenever
    click
    mcp
  ];
})
