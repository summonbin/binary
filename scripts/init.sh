#!/bin/sh
DRIVER_NAME="binary"
VERSION="0.1.0"
BASE_URL="https://raw.githubusercontent.com/summonbin/binary"


###################
#### Arguments ####
###################

INSTALL_PATH=$1
SCHEME_PATH=$2


######################
#### Build driver ####
######################

mkdir -p $INSTALL_PATH/$DRIVER_NAME
curl -L "$BASE_URL/$VERSION/scripts/run.sh" -o "$INSTALL_PATH/$DRIVER_NAME/run.sh"


######################
#### Build scheme ####
######################

mkdir -p $SCHEME_PATH/$DRIVER_NAME
echo "$INSTALL_PATH/cache/$DRIVER_NAME" > $SCHEME_PATH/$DRIVER_NAME/cache
