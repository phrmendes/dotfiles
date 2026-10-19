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
    # withPlugins returns a wrapper without shellPath. Add it so the wrapper can
    # be used as a login shell.
    passthru = (old.passthru or { }) // {
      shellPath = "/bin/nu";
    };
  })
