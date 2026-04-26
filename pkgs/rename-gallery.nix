{
  writeShellApplication,
  exiftool,
  ffmpeg,
  imagemagick,
  parallel,
}:
writeShellApplication {
  name = "rename-gallery";
  runtimeInputs = [
    exiftool
    ffmpeg
    imagemagick
    parallel
  ];
  text = builtins.readFile ../files/scripts/rename-gallery.sh;
}
