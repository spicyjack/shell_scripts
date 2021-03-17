#!/bin/bash

# Run SQLite3 from Homebrew
SQLITE_VERSION="3.34.1"
SQLITE_DIR="/usr/local/Cellar/sqlite/${SQLITE_VERSION}"

if [ ! -d $SQLITE_DIR ]; then
  echo "ERROR: Missing SQLite folder; possible Homebrew upgrade?"
  echo "ERROR: Searched: ${SQLITE_DIR}"
  exit 1
fi
$SQLITE_DIR/bin/sqlite3 "$@"

# vim: filetype=sh tabstop=2 shiftwidth=2
