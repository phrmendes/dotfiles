{
  lib,
  stdenv,
  coreutils,
  python3Packages,
  src,
  ustreamer,
  libxkbcommon,
}:

python3Packages.buildPythonApplication {
  pname = "kvmd";
  version = "4.180";
  pyproject = true;
  __structuredAttrs = true;

  inherit src;

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    aiofiles
    aiohttp
    async-lru
    bcrypt
    dbus-next
    evdev
    gpiod
    mako
    netifaces
    passlib
    pillow
    psutil
    pygments
    pyotp
    pyserial
    pyudev
    pyyaml
    pyusb
    python-xlib
    ruamel-yaml
    setproctitle
    systemd-python
    ustreamer
    zstandard
  ];

  buildInputs = [ libxkbcommon ];

  postPatch = ''
    substituteInPlace kvmd/apps/_scheme.py \
      --replace-fail 'Option(["/usr/bin/vcgencmd"], type=valid_command)' 'Option(["/usr/bin/vcgencmd"], type=valid_options)' \
      --replace-fail '"/bin/true"' '"${lib.getExe' coreutils "true"}"' \
      --replace-fail '"/usr/share/kvmd/keymaps/en-us"' '"${placeholder "out"}/share/kvmd/keymaps/en-us"' \
      --replace-fail '"/usr/bin/sudo"' '"/run/wrappers/bin/sudo"' \
      --replace-fail '"/usr/bin/kvmd-helper-' '"/run/current-system/sw/bin/kvmd-helper-'
    substituteInPlace kvmd/apps/kvmd/info/health.py \
      --replace-fail 'flags = await self.__parse_vcgencmd(' \
        'flags = None if not self.__vcgencmd_cmd else await self.__parse_vcgencmd('
    substituteInPlace kvmd/apps/__init__.py \
      --replace-fail '"/usr/lib/kvmd/main.yaml"' '"/etc/kvmd/main.yaml"'
    substituteInPlace kvmd/libc.py \
      --replace-fail 'ctypes.util.find_library("c")' '"${stdenv.cc.libc}/lib/libc.so.6"'
    substituteInPlace kvmd/keyboard/printer.py \
      --replace-fail 'ctypes.util.find_library("xkbcommon")' '"${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0"'
    substituteInPlace configs/nginx/kvmd.ctx-server.conf \
      --replace-fail '/usr/share/kvmd/web' '${placeholder "out"}/share/kvmd/web'
  '';

  postInstall = ''
    cd $out/bin
    rm -f kvmd-edidconf kvmd-helper-swapfiles kvmd-ipmi kvmd-janus kvmd-localhid kvmd-media kvmd-nbd \
      kvmd-oled kvmd-otgconf kvmd-otgnet kvmd-override kvmd-pst kvmd-pstrun kvmd-totp kvmd-vnc kvmd-watchdog
    cd "$OLDPWD"

    mkdir -p $out/share/kvmd
    cp -r web $out/share/kvmd/
    cp -r contrib/keymaps $out/share/kvmd/keymaps
    find $out/share/kvmd/web -name '*.pug' -delete
    cp -r configs $out/share/kvmd/configs.default
  '';

  pythonImportsCheck = [
    "kvmd"
    "kvmd.apps.kvmd"
    "kvmd.apps.htpasswd"
    "kvmd.apps.ngxmkconf"
    "kvmd.apps.otg"
    "kvmd.apps.otgmsd"
    "kvmd.plugins.atx.disabled"
    "kvmd.plugins.auth.htpasswd"
    "kvmd.plugins.hid.otg"
    "kvmd.plugins.msd.disabled"
    "kvmd.plugins.msd.otg"
    "kvmd.plugins.ugpio.gpio"
  ];

  meta = {
    description = "The main PiKVM daemon";
    homepage = "https://github.com/pikvm/kvmd";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "kvmd";
  };
}
