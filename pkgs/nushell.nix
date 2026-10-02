{ nushell, nushellPlugins }:

nushell.withPlugins (
  with nushellPlugins;
  [
    polars
    gstat
  ]
)
