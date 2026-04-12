_: {
  modules.homeManager.workstation.keepassxc =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      configDir = ".config/keepassxc";
      localConfigPath = "${config.home.homeDirectory}/${configDir}/keepassxc-local.ini";
      iniFiles = [
        {
          name = "keepassxc.ini";
          drv = pkgs.writeText "keepassxc.ini" (
            lib.generators.toINI { } {
              General = {
                ConfigVersion = 2;
                MinimizeAfterUnlock = false;
              };
              Browser.Enabled = true;
              FdoSecrets = {
                ConfirmAccessItem = false;
                ConfirmDeleteItem = false;
                Enabled = true;
                NoConfirmAccessEnabled = true;
              };
              GUI = {
                ApplicationTheme = "dark";
                CompactMode = true;
                MinimizeOnClose = true;
                MinimizeToTray = true;
                MonospaceNotes = true;
                ShowExpiredEntriesOnDatabaseUnlockOffsetDays = 6;
                ShowTrayIcon = true;
                TrayIconAppearance = "monochrome-light";
              };
              PasswordGenerator = {
                Type = 1;
                WordCase = 2;
                WordSeparator = "-";
              };
              SSHAgent.Enabled = true;
              Security = {
                ClearClipboardTimeout = 30;
                IconDownloadFallback = true;
              };
            }
          );
        }
        {
          name = "keepassxc-local.ini";
          drv = pkgs.writeText "keepassxc-local.ini" (
            lib.generators.toINI { } {
              SSHAgent.AuthSockOverride = "/run/user/1000/ssh-agent";
            }
          );
        }
      ];
      copyIni =
        {
          name,
          drv,
          cmd ? "",
        }:
        ''
          ${cmd} cp ${drv} "$HOME/${configDir}/${name}"
          ${cmd} chmod 600 "$HOME/${configDir}/${name}"
        '';
    in
    {
      programs.keepassxc.enable = true;

      xdg.portal.config.common."org.freedesktop.impl.portal.Secret" = [ "keepassxc" ];

      systemd.user.services.keepassxc = {
        Unit = {
          Description = "KeePassXC password manager";
          After = [ "tray.target" ];
          Requires = [ "tray.target" ];
        };
        Service = {
          Type = "simple";
          ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
          ExecStart = "${config.programs.keepassxc.package}/bin/keepassxc --minimized";
          Environment = "KPXC_CONFIG_LOCAL=${localConfigPath}";
        };
        Install.WantedBy = [ "tray.target" ];
      };

      home.activation.keepassxcIni =
        iniFiles
        |> lib.concatMapStrings (
          { name, drv }:
          ''
            if [[ ! -f "$HOME/${configDir}/${name}" ]]; then
              ${copyIni {
                inherit name drv;
                cmd = "$DRY_RUN_CMD";
              }}
            fi
          ''
        )
        |> lib.hm.dag.entryAfter [ "writeBoundary" ];

      home.file =
        iniFiles
        |> map (
          { name, drv }:
          {
            name = "${configDir}/.${name}.nix";
            value = {
              source = drv;
              onChange = copyIni { inherit name drv; };
            };
          }
        )
        |> lib.listToAttrs;
    };
}
