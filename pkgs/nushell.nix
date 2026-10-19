{ nushell, nushellPlugins }:

nushell.withPlugins (
  with nushellPlugins;
  [
    formats
    gstat
    polars
    query
  ]
)
