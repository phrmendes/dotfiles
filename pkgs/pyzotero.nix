{ python314Packages }:

python314Packages.pyzotero.overridePythonAttrs (old: {
  dependencies = old.dependencies ++ [
    python314Packages.click
    python314Packages.mcp
  ];
})
