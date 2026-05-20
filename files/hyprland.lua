local nix = require("nix")

hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")

hl.config({
  input = {
    kb_layout = "us,br",
    kb_model = "pc104",
    kb_rules = "evdev",
    kb_options = "grp:alt_space_toggle",
    numlock_by_default = true,
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = { natural_scroll = true },
  },
  general = {
    gaps_in = 3,
    gaps_out = 8,
    border_size = 2,
    layout = "scrolling",
    resize_on_border = true,
    col = {
      active_border = nix.colors.base0D,
      inactive_border = nix.colors.base03,
    },
  },
  decoration = {
    active_opacity = 1,
    inactive_opacity = 0.9,
    rounding = 10,
    rounding_power = 2,
    shadow = {
      enabled = true,
      range = 4,
      render_power = 3,
      color = nix.colors.base00 .. "cc",
    },
    blur = {
      enabled = true,
      size = 3,
      passes = 2,
      vibrancy = 0.1696,
    },
  },
  animations = { enabled = true },
  dwindle = { preserve_split = true },
  scrolling = {
    column_width = 0.5,
    fullscreen_on_one_column = true,
    focus_fit_method = 1,
    follow_focus = true,
    follow_min_visible = 0.4,
    wrap_focus = true,
    wrap_swapcol = true,
    direction = "right",
  },
  group = {
    col = {
      border_active = nix.colors.base0D,
      border_inactive = nix.colors.base03,
      border_locked_active = nix.colors.base0B,
    },
    groupbar = {
      col = {
        active = nix.colors.base0D,
        inactive = nix.colors.base03,
      },
      text_color = nix.colors.base05,
    },
  },
  misc = {
    vrr = 1,
    force_default_wallpaper = 0,
    background_color = nix.colors.base00,
    disable_hyprland_logo = true,
  },
  debug = { damage_tracking = 2 },
  ecosystem = { enforce_permissions = true },
})

hl.monitor({
  output = nix.monitors.primary.name,
  mode = nix.monitors.primary.mode,
  position = nix.monitors.primary.position,
  scale = nix.monitors.primary.scale,
})

if nix.monitors.secondary then
  hl.monitor({
    output = nix.monitors.secondary.name,
    mode = nix.monitors.secondary.mode,
    position = nix.monitors.secondary.position,
    scale = nix.monitors.secondary.scale,
  })
end

for i = 1, 7 do
  hl.workspace_rule({ workspace = tostring(i), monitor = nix.monitors.primary.name })
end

for i = 8, 9 do
  hl.workspace_rule({ workspace = tostring(i), monitor = (nix.monitors.secondary or nix.monitors.primary).name })
end

if nix.is_laptop then
  hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia-shell ipc call brightness increase"), { repeating = true })
  hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia-shell ipc call brightness decrease"), { repeating = true })
end

hl.permission({ binary = "/nix/store/.*/vesktop", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/nix/store/.*/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
hl.window_rule({ match = { class = ".blueman-manager-wrapped" }, float = true, opaque = true })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" }, float = true, opaque = true, stay_focused = true })
hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, float = true })
hl.window_rule({ match = { class = "firefox" }, opaque = true, scrolling_width = 0.667 })
hl.window_rule({ match = { class = "mpv" }, opaque = true })

hl.layer_rule({
  match = { namespace = "noctalia-shell:regionSelector" },
  name = "noctalia-screenshot",
  no_anim = true,
})

hl.layer_rule({
  match = { namespace = "noctalia-background-.*" },
  name = "noctalia",
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})

hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("noctalia-shell ipc call lockScreen lock"))
hl.bind("SHIFT + print", hl.dsp.exec_cmd("noctalia-shell ipc call plugin:screen-shot-and-record record"))
hl.bind("SUPER + ALT + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind("SUPER + ALT + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + B", hl.dsp.exec_cmd("firefox"))
hl.bind("SUPER + CTRL + H", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("SUPER + CTRL + L", hl.dsp.focus({ workspace = "e+1" }))
hl.bind("SUPER + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + G", hl.dsp.group.toggle())
hl.bind("SUPER + H", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + L", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + R", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + E", hl.dsp.layout("consume_or_expel"))
hl.bind("SUPER + comma", hl.dsp.layout("swapcol l"))
hl.bind("SUPER + period", hl.dsp.layout("swapcol r"))
hl.bind("SUPER + minus", hl.dsp.layout("fit active"))
hl.bind("SUPER + equal", hl.dsp.layout("fit all"))
hl.bind("SUPER + SHIFT + CTRL + H", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind("SUPER + SHIFT + CTRL + L", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + T", hl.dsp.group.lock_active())
hl.bind("SUPER + V", hl.dsp.exec_cmd("noctalia-shell ipc call plugin:clipboard toggle"))
hl.bind("SUPER + Z", hl.dsp.window.fullscreen())
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + return", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + space", hl.dsp.exec_cmd("noctalia-shell ipc call launcher toggle"))
hl.bind("SUPER + tab", hl.dsp.group.next())
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia-shell ipc call volume decrease"), { repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia-shell ipc call volume muteInput"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia-shell ipc call volume muteOutput"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia-shell ipc call volume increase"), { repeating = true })
hl.bind("print", hl.dsp.exec_cmd("noctalia-shell ipc call plugin:screen-shot-and-record screenshot"))

for i = 1, 9 do
  hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
  hl.bind("SUPER + SHIFT + CTRL + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end
