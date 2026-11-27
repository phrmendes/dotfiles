return {
  before_init = function(_, config) table.insert(config.init_options.command, "--issues-exit-code=1") end,
}
