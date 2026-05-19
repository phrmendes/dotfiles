---@meta

---@class NixPalette
---@field base00 string
---@field base01 string
---@field base02 string
---@field base03 string
---@field base04 string
---@field base05 string
---@field base06 string
---@field base07 string
---@field base08 string
---@field base09 string
---@field base0A string
---@field base0B string
---@field base0C string
---@field base0D string
---@field base0E string
---@field base0F string

---@class NixMonitor
---@field name string
---@field mode string
---@field position string
---@field scale number

---@class NixMonitors
---@field primary NixMonitor
---@field secondary NixMonitor?

---@class Nix
---@field colors NixPalette
---@field is_laptop boolean
---@field monitors NixMonitors
