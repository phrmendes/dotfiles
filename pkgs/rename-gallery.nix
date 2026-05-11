{
  writeShellApplication,
  exiftool,
  ffmpeg,
  imagemagick,
  parallel,
}:
writeShellApplication {
  name = "rename-gallery";
  excludeShellChecks = [ "SC2154" ];
  runtimeInputs = [
    exiftool
    ffmpeg
    imagemagick
    parallel
  ];
  text = ''
    dir="''${1:-.}"
    dry_run=false
    jobs="$(nproc)"

    while [[ $# -gt 0 ]]; do
      case $1 in
        -n|--dry-run) dry_run=true; shift ;;
        -j|--jobs) jobs="$2"; shift 2 ;;
        *) dir="$1"; shift ;;
      esac
    done

    fmt='%Y-%m-%d_%H-%M-%S%%-c'

    rename_arg="filename"
    [[ $dry_run == true ]] && rename_arg="testname"

    exiftool -r -d "$fmt" \
      "-''${rename_arg}<''${DateTimeOriginal}''${SubSecTimeOriginal;s/(.+)/-$1/}.%le" \
      "-''${rename_arg}<''${FileModifyDate}.%le" \
      "$dir"

    [[ $dry_run == true ]] && exit 0

    convert_photo() {
      local f="$1"
      local out="''${f%.*}.jpg"
      magick "$f" -quality 95 "$out" && rm -f "$f"
    }

    convert_video() {
      local f="$1"
      local out="''${f%.*}.mp4"
      ffmpeg -i "$f" -c:v libx264 -c:a aac -movflags +faststart "$out" -y 2>/dev/null && rm -f "$f"
    }

    export -f convert_photo convert_video

    find "$dir" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpeg" \) |
      parallel -j "$jobs" convert_photo {}

    find "$dir" -maxdepth 1 -type f \( -iname "*.mov" -o -iname "*.avi" \) |
      parallel -j "$jobs" convert_video {}
  '';
}
