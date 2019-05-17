#!/bin/sh

set -e

VERSION_FILE="${TARGET_DIR}/etc/version"

commit_id() {
  git rev-parse --short HEAD
}

branch() {
  git rev-parse --abbrev-ref HEAD
}

COMMIT=$(cd ${TARGET_DIR} && commit_id)
BRANCH=$(cd ${TARGET_DIR} && branch)
# Save captured version info to dedicated file
echo "VERSION=$BRANCH" > $VERSION_FILE
echo "COMMIT=$COMMIT" >> $VERSION_FILE

