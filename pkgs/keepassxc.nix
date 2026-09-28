{
  coreutils,
  keepassxc,
  systemd,
  writeShellApplication,
}:
writeShellApplication {
  name = "keepassxc";
  runtimeInputs = [
    coreutils
    keepassxc
    systemd
  ];
  text = ''
    readonly service=org.kde.StatusNotifierWatcher
    readonly object=/StatusNotifierWatcher
    readonly interface=org.kde.StatusNotifierWatcher

    while ! busctl --user --quiet --timeout=1 call "$service" "$object" "$interface" GetRegisteredItems >/dev/null 2>&1; do
      sleep 0.1
    done

    exec keepassxc
  '';
}
