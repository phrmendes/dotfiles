{
  # zoxide ages the database when sum(rank) > _ZO_MAXAGE (set in the nushell
  # module). Aging multiplies every rank by 0.9 * maxage / total and
  # deletes each entry that drops below 1.0, so newly visited directories
  # (rank 1.0) are removed. `zoxide import atuin` seeds one rank-1.0 entry per
  # history transition and `--merge` sums the whole history again on every
  # run, which inflates the total and triggers that prune. Import once,
  # without `--merge`, into a deleted database.
  homeModules.zoxide = {
    programs.zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
