{ nushell, nushellPlugins }:

(nushell.withPlugins (
  with nushellPlugins;
  [
    formats
    gstat
    polars
    query
  ]
)).overrideAttrs
  (old: {
    passthru = (old.passthru or { }) // {
      shellPath = "/bin/nu";
    };
  })
