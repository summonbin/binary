#!/bin/bash -e

# Arguments
CONFIG_DIR=$1
BIN_NAME=$2
SOURCE_TYPE=$3

# Configurations
BIN_CACHE_CONFIG_FILE="$CONFIG_DIR/cache"

if [ -f "$BIN_CACHE_CONFIG_FILE" ]
then
  BIN_CACHE_DIR=$(eval echo "$(< "$BIN_CACHE_CONFIG_FILE")")
else
  exit 1
fi

# Prepare binary
if [ "$SOURCE_TYPE" = "git" ]
then
  GIT_URL=$4
  GIT_BRANCH=$5
  BIN_SUB_PATH=$6
  set -- "${@:7}"

  REPO_DIR="$BIN_CACHE_DIR/git/$BIN_NAME/$GIT_BRANCH"
  BIN_PATH="$REPO_DIR/$BIN_SUB_PATH/$BIN_NAME"

  if [ ! -f "$BIN_PATH" ]
  then
    rm -rf "$REPO_DIR"
    git clone "$GIT_URL" "$REPO_DIR" -b "$GIT_BRANCH" --single-branch --depth 1
  fi
elif [ "$SOURCE_TYPE" = "archive" ]
then
  DOWNLOAD_URL=$4
  BIN_SUB_PATH=$5
  set -- "${@:6}"

  DOWNLOAD_FILE_NAME="${DOWNLOAD_URL##*/}"
  DOWNLOAD_DIR="$BIN_CACHE_DIR/archive/$BIN_NAME/$DOWNLOAD_FILE_NAME/download"
  CONTENT_DIR="$BIN_CACHE_DIR/archive/$BIN_NAME/$DOWNLOAD_FILE_NAME/content"
  BIN_PATH="$CONTENT_DIR/$BIN_SUB_PATH/$BIN_NAME"

  if [ ! -f "$BIN_PATH" ]
  then
    mkdir -p "$DOWNLOAD_DIR"
    curl -L -C - "$DOWNLOAD_URL" -o "$DOWNLOAD_DIR/$DOWNLOAD_FILE_NAME"
    rm -rf "$CONTENT_DIR"
    unzip "$DOWNLOAD_DIR/$DOWNLOAD_FILE_NAME" -d "$CONTENT_DIR"
  fi
fi

# Execute binary
if [ -t 1 ]
then
  eval "$BIN_PATH" "$@" < /dev/tty
else
  eval "$BIN_PATH" "$@"
fi
