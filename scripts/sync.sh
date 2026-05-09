#!/bin/sh
set -eu

log() {
  printf '%s\n' "$*"
}

die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}

SCRIPT_DIR=$(cd "$(dirname "$0")" >/dev/null 2>&1 && pwd)
ROOT_DIR=$(cd "$SCRIPT_DIR/.." >/dev/null 2>&1 && pwd)

verify_static() {
  [ -f "$ROOT_DIR/index.html" ] || die "Missing $ROOT_DIR/index.html"
  [ -f "$ROOT_DIR/styles.css" ] || die "Missing $ROOT_DIR/styles.css"
  [ -d "$ROOT_DIR/assets" ] || die "Missing $ROOT_DIR/assets/"
}

sync_to_target() {
  target="$1"
  [ -n "$target" ] || die "OPENHOUSE_GUIDE_TARGET is set but empty"
  mkdir -p "$target"

  cp -f "$ROOT_DIR/index.html" "$target/"
  cp -f "$ROOT_DIR/styles.css" "$target/"
  cp -R "$ROOT_DIR/assets" "$target/"
}

main() {
  verify_static
  log "ok: static files present"

  if [ -n "${OPENHOUSE_GUIDE_TARGET:-}" ]; then
    log "sync: copying to OPENHOUSE_GUIDE_TARGET=$OPENHOUSE_GUIDE_TARGET"
    sync_to_target "$OPENHOUSE_GUIDE_TARGET"
    log "done"
  else
    log "OPENHOUSE_GUIDE_TARGET not set; nothing copied"
  fi
}

main "$@"

