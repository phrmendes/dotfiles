{ inputs, ... }:
{
  modules.homeManager.workstation.noctalia =
    {
      pkgs,
      config,
      lib,
      osConfig,
      ...
    }:
    let
      c = config.lib.stylix.colors.withHashtag;
      pluginSourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
      inherit (osConfig.machine) isLaptop;
      primaryMonitor = osConfig.machine.monitors.primary.name;
    in
    {
      imports = [ inputs.noctalia.homeModules.default ];

      stylix.targets.qt.enable = lib.mkForce false;

      programs.noctalia-shell = {
        enable = true;
        colors = {
          mPrimary = lib.mkForce c.base0D;
          mOnPrimary = lib.mkForce c.base00;
          mSecondary = lib.mkForce c.base0C;
          mOnSecondary = lib.mkForce c.base00;
          mTertiary = lib.mkForce c.base0E;
          mOnTertiary = lib.mkForce c.base00;
          mError = lib.mkForce c.base08;
          mOnError = lib.mkForce c.base00;
          mSurface = lib.mkForce c.base00;
          mOnSurface = lib.mkForce c.base05;
          mHover = lib.mkForce c.base01;
          mOnHover = lib.mkForce c.base06;
          mSurfaceVariant = lib.mkForce c.base01;
          mOnSurfaceVariant = lib.mkForce c.base04;
          mOutline = lib.mkForce c.base03;
          mShadow = lib.mkForce c.base00;
        };
        plugins = {
          sources = [
            {
              enabled = true;
              name = "Official Noctalia Plugins";
              url = pluginSourceUrl;
            }
          ];
          states = {
            clipboard = {
              enabled = true;
              sourceUrl = pluginSourceUrl;
            };
            screen-shot-and-record = {
              enabled = true;
              sourceUrl = pluginSourceUrl;
            };
            usb-drive-manager = {
              enabled = true;
              sourceUrl = pluginSourceUrl;
            };
          };
          version = 2;
        };
        pluginSettings = {
          screen-shot-and-record = {
            screenshotEditor = "satty";
            savePath = "~/Pictures/Screenshots";
            recordingSavePath = "~/Videos/Screenrecordings";
          };
          usb-drive-manager = {
            autoMount = false;
            fileBrowser = "${lib.getExe pkgs.thunar}";
            notifications = true;
          };
        };
        settings = lib.mkForce {
          bar = {
            barType = "simple";
            density = "compact";
            position = "top";
            showCapsule = false;
            backgroundOpacity = 0.93;
            widgetSpacing = 0;
            monitors = [ primaryMonitor ];
            widgets = {
              left = [
                {
                  id = "ControlCenter";
                  useDistroLogo = true;
                  icon = "noctalia";
                  colorizeDistroLogo = false;
                  enableColorization = true;
                  colorizeSystemIcon = "none";
                  colorizeSystemText = "none";
                  customIconPath = "";
                }
                {
                  id = "ActiveWindow";
                  colorizeIcons = false;
                  hideMode = "hidden";
                  maxWidth = 145;
                  scrollingMode = "hover";
                  showIcon = true;
                  showText = true;
                  textColor = "none";
                  useFixedWidth = false;
                }
              ];
              center = [
                {
                  id = "Workspace";
                  labelMode = "number";
                  characterCount = 2;
                  colorizeIcons = false;
                  emptyColor = "secondary";
                  enableScrollWheel = true;
                  focusedColor = "primary";
                  followFocusedScreen = false;
                  fontWeight = "bold";
                  groupedBorderOpacity = 1;
                  hideUnoccupied = false;
                  iconScale = 0.8;
                  occupiedColor = "secondary";
                  pillSize = 0.6;
                  showApplications = false;
                  showApplicationsHover = false;
                  showBadge = true;
                  showLabelsOnlyWhenOccupied = true;
                  unfocusedIconsOpacity = 1;
                }
              ];
              right = [
                {
                  id = "Tray";
                  chevronColor = "none";
                  colorizeIcons = false;
                  drawerEnabled = true;
                  hidePassive = true;
                }
                { id = "KeepAwake"; }
                {
                  id = "plugin:usb-drive-manager";
                  hideWhenEmpty = true;
                  iconColor = "none";
                }
                {
                  id = "SystemMonitor";
                  compactMode = true;
                  diskPath = "/";
                  iconColor = "none";
                  showCpuCores = false;
                  showCpuFreq = false;
                  showCpuTemp = true;
                  showCpuUsage = true;
                  showDiskAvailable = false;
                  showDiskUsage = false;
                  showDiskUsageAsPercent = false;
                  showGpuTemp = false;
                  showLoadAverage = false;
                  showMemoryAsPercent = false;
                  showMemoryUsage = true;
                  showNetworkStats = false;
                  showSwapUsage = false;
                  textColor = "none";
                  useMonospaceFont = true;
                  usePadding = false;
                }
                {
                  id = "Volume";
                  displayMode = "onhover";
                  iconColor = "none";
                  middleClickCommand = "pwvucontrol || pavucontrol";
                  textColor = "none";
                }
                {
                  id = "Battery";
                  deviceNativePath = "__default__";
                  displayMode = "graphic-clean";
                  hideIfIdle = false;
                  hideIfNotDetected = true;
                  showNoctaliaPerformance = isLaptop;
                  showPowerProfiles = isLaptop;
                }
                {
                  id = "Clock";
                  clockColor = "none";
                  customFont = "";
                  formatHorizontal = "HH:mm ddd, MMM dd";
                  formatVertical = "HH mm - dd MM";
                  tooltipFormat = "HH:mm ddd, MMM dd";
                  useCustomFont = false;
                }
              ];
            };
          };
          general = {
            radiusRatio = 0.2;
            clockStyle = "digital";
            clockFormat = "HH:mm ddd, MMM dd";
            compactLockScreen = true;
            lockScreenAnimations = true;
            enableBlurBehind = true;
            enableShadows = true;
          };
          colorSchemes.useWallpaperColors = false;
          ui = {
            fontDefault = config.stylix.fonts.sansSerif.name;
            fontFixed = config.stylix.fonts.monospace.name;
          };
          notifications = {
            enabled = true;
            density = "compact";
            monitors = [ primaryMonitor ];
          };
          dock.enabled = false;
          appLauncher = {
            iconMode = "tabler";
            density = "comfortable";
            terminalCommand = "${lib.getExe pkgs.kitty} -e";
            enableSettingsSearch = true;
          };
          idle = {
            enabled = true;
            screenOffTimeout = 600;
            lockTimeout = 660;
            suspendTimeout = 1800;
          };
          nightLight = {
            enabled = true;
            autoSchedule = true;
            nightTemp = "4000";
            dayTemp = "6500";
          };
          location = {
            name = "São Paulo";
            weatherEnabled = true;
            weatherShowEffects = true;
            autoLocate = false;
          };
          noctaliaPerformance = {
            disableWallpaper = true;
            disableDesktopWidgets = true;
          };
          wallpaper = {
            enabled = true;
            directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
          };
        };
      };
    };
}
