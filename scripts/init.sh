#!/bin/sh
DRIVER_NAME="binary"
VERSION="0.1.0"
BASE_URL="https://raw.githubusercontent.com/summonbin/binary"


###################
#### Arguments ####
###################

INSTALL_PATH=$1
SCHEME_PATH=$2
DEFAULT_CACHE_PATH=$3


######################
#### Build driver ####
######################

mkdir -p $INSTALL_PATH/$DRIVER_NAME
curl -L "$BASE_URL/$VERSION/scripts/run.sh" -o "$INSTALL_PATH/$DRIVER_NAME/run.sh"


######################
#### Build scheme ####
######################

mkdir -p $SCHEME_PATH/$DRIVER_NAME
if [ ! -f "$SCHEME_PATH/$DRIVER_NAME/cache" ]
then
  echo "$DEFAULT_CACHE_PATH/$DRIVER_NAME" > "$SCHEME_PATH/$DRIVER_NAME/cache"
fi
