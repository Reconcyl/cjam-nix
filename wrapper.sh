if [[ "$#" -eq 0 ]]; then
  jclass='net.aditsu.cjam.Shell'
  exec $java "$jclass" "$@"
else
  jclass='net.aditsu.cjam.CJam'
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -r) jclass='net.aditsu.cjam.JamCode'
          shift ;;
      -c) cjam_code="$2"
          exec $java "$jclass" <(printf "%s" "$cjam_code") "${@:3}"
          break ;;
      -h) echo "$src"
          exit 0 ;;
      -*) echo "cjam: unknown flag: $1" >&2
          exit 1 ;;
      *)  exec $java "$jclass" "$@"
          break ;;
    esac
  done
fi
