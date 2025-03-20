{ parameters, ... }:
{
  services.syncthing = {
    inherit (parameters) user;
    enable = true;
    configDir = "${parameters.home}/.config/syncthing";
    openDefaultPorts = true;
    overrideDevices = true;
    relay.enable = true;
    settings = {
      options = {
        globalAnnounceEnabled = true;
        relaysEnabled = true;
        urAccepted = 1;
      };
      devices = {
        "phone" = {
          id = "XIO67NF-ENODCEU-AXYLQBT-TNYRTXK-UXOWJX3-S4AZ23F-EIN2CAI-UI6DMQH";
          autoAcceptFolders = true;
        };
        "tablet" = {
          id = "ME77KQY-MGUM34F-M6RI4DI-EPNNS2P-FSPEYB6-2XUHYZB-5MGG7BV-XJTGAQO";
          autoAcceptFolders = true;
        };
        "orangepizero2" = {
          id = "BVM7PXK-VIQOZQ4-Z3RFYNH-33GVYPJ-WYSRYBK-3DQ2N2X-JJXXI56-7OSSKQW";
          autoAcceptFolders = true;
        };
        "laptop" = {
          id = "UDC7ERC-4U3ANWI-FCND77N-MNIZHXG-IXQTU42-TMOGIOY-7SXE2DV-UOCCUAC";
          autoAcceptFolders = true;
        };
        "desktop" = {
          id = "V3YDAIH-HZAJKMP-GZEYKK4-WEA4F2H-MSVSXFA-6XUTGTF-XSXCSG7-TRFW5AZ";
          autoAcceptFolders = true;
        };
      };
    };
  };
}
