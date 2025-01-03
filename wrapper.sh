if [[ "$#" -eq 0 ]]; then
  jclass='net.aditsu.cjam.Shell'
  # shellcheck disable=SC2086
  exec rlwrap -O"> " -S"> " -- $java "$jclass" "$@"
else
  jclass='net.aditsu.cjam.CJam'
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      -r) jclass='net.aditsu.cjam.JamCode'
          shift ;;
      -c) cjam_code="$2"
          exec $java "$jclass" <(printf "%s" "$cjam_code") "${@:3}"
          break ;;
      -h) echo "Usage:"
          echo " $0                              start a REPL"
          echo " $0 [OPTIONS]... <cjam file>     execute the given file"
          echo " $0 [OPTIONS]... -c <cjam code>  execute literal CJam code"
          echo " $0 -h                           display this help"
          echo " $0 -s                           display path to sources"
          echo
          echo "Options:"
          echo " -r  run multiple iterations (JamCode)"
          echo
          exit 0 ;;
      -s) echo "$src"
          exit 0 ;;
      -*) echo "cjam: unknown option: $1" >&2
          exit 1 ;;
      *)  exec $java "$jclass" "$@"
          break ;;
    esac
  done
fi
