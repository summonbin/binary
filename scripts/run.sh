#!/bin/bash -e
###################
#### Arguments ####
###################

CONFIG_DIR=$1
BIN_NAME=$2
SOURCE_TYPE=$3
BIN_ARGS=()

for i
do
  BIN_ARGS+=(\"${i}\")
done


#####################
#### Read config ####
#####################

BIN_CACHE_DIR=$( eval "echo $(<"$CONFIG_DIR/cache")" )


#########################
#### Download binary ####
#########################

if [ "$SOURCE_TYPE" = "repo" ]
then
  GIT_URL=$4
  GIT_BRANCH=$5
  BIN_SUB_PATH=$6

  # Arguments for bin
  unset BIN_ARGS[0]
  unset BIN_ARGS[1]
  unset BIN_ARGS[2]
  unset BIN_ARGS[3]
  unset BIN_ARGS[4]
  unset BIN_ARGS[5]
  BIN_ARGS=${BIN_ARGS[@]}

  REPO_DIR="$BIN_CACHE_DIR/$BIN_NAME/$GIT_BRANCH"
  BIN_PATH="$REPO_DIR/$BIN_SUB_PATH/$BIN_NAME"

  # Clone repository
  if [ ! -f "$BIN_PATH" ]
  then
    rm -rf "$REPO_DIR"
    git clone "$GIT_URL" "$REPO_DIR" -b "$GIT_BRANCH" --single-branch --depth 1
  fi
elif [ "$SOURCE_TYPE" = "download" ]
then
  DOWNLOAD_URL=$4
  BIN_SUB_PATH=$5

  # Arguments for bin
  unset BIN_ARGS[0]
  unset BIN_ARGS[1]
  unset BIN_ARGS[2]
  unset BIN_ARGS[3]
  unset BIN_ARGS[4]
  BIN_ARGS=${BIN_ARGS[@]}

  DOWNLOAD_FILE_NAME="${DOWNLOAD_URL##*/}"
  DOWNLOAD_DIR="$BIN_CACHE_DIR/$BIN_NAME/$DOWNLOAD_FILE_NAME/download"
  CONTENT_DIR="$BIN_CACHE_DIR/$BIN_NAME/$DOWNLOAD_FILE_NAME/content"
  BIN_PATH="$CONTENT_DIR/$BIN_SUB_PATH/$BIN_NAME"

  # Download and unzip file
  if [ ! -f "$BIN_PATH" ]
  then
    mkdir -p "$DOWNLOAD_DIR"
    curl -L -C - "$DOWNLOAD_URL" -o "$DOWNLOAD_DIR/$DOWNLOAD_FILE_NAME"
    rm -rf "$CONTENT_DIR"
    unzip "$DOWNLOAD_DIR/$DOWNLOAD_FILE_NAME" -d "$CONTENT_DIR"
  fi
fi


########################
#### Execute binary ####
########################

if [ -t 1 ]
then
  eval $BIN_PATH $BIN_ARGS < /dev/tty
else
  eval $BIN_PATH $BIN_ARGS
fi
