{ nushell, nushellPlugins }:

(nushell.withPlugins (
  with nushellPlugins;
  [
    formats
    gstat
    polars
    query
    skim
  ]
)).overrideAttrs
  (old: {
    passthru = (old.passthru or { }) // {
      shellPath = "/bin/nu";
    };
  })
