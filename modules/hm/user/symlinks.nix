_: {
  modules.homeManager.user.symlinks = {
    home.file.".face.icon".source = ../../../files/face.png;

    xdg.configFile."satty/config.toml".source = ../../../files/satty.toml;
  };
}
