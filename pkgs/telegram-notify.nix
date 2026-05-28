{ writeShellApplication, apprise }:
writeShellApplication {
  name = "telegram-notify";
  runtimeInputs = [ apprise ];
  text = ''
    LEVEL="$1"; TITLE="$2"; BODY="$3"

    case "$LEVEL" in
      info)  PREFIX="ℹ️ " ;;
      warn)  PREFIX="⚠️ " ;;
      error) PREFIX="❌ " ;;
      *)     echo "Unknown level: $LEVEL" >&2; exit 1 ;;
    esac

    apprise --input-format html -t "''${PREFIX}$TITLE" -b "$BODY" "tgram://$TELEGRAM_BOT_TOKEN/$TELEGRAM_CHAT_ID"
  '';
}
