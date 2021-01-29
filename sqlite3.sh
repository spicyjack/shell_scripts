#!/bin/bash

# Run SQLite3 from Homebrew
SQLITE_VERSION="3.34.0"

/usr/local/Cellar/sqlite/${SQLITE_VERSION}/bin/sqlite3 "$@"

# vim: filetype=sh tabstop=2 shiftwidth=2
