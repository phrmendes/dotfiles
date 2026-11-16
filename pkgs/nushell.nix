{ nushell }:

plugins:

(nushell.withPlugins plugins).overrideAttrs (old: {
  passthru = (old.passthru or { }) // {
    shellPath = "/bin/nu";
  };
})
