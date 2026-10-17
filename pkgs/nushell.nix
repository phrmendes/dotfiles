{ nushell, nushellPlugins }:

nushell.withPlugins (
  with nushellPlugins;
  [
    formats
    gstat
    inc
    polars
    query
  ]
)
