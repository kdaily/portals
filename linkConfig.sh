#!/bin/bash
# Usage:
#   Run portal with the app-template
#     ./run.sh [portal-folder-name]
#
if [[ -z $1 ]]; then
  echo Usage: ./run.sh [portal-folder-name] [optional-reset-flag]
  exit 1
fi
if [ ! -z $2 ] && [ "$2" != "-r" ]; then
  echo Usage: ./run.sh [portal-folder-name] [-r to reset last link]
  exit 1
fi
# remove ending slash if directory given had a slash
folderNoSlash=${1%/}

CONFIG_FOLDER=src/config
ACTIVE_CONFIGURATION=src/configurations/$folderNoSlash

# we want to always make sure that the linking is undone after this script so we capture
# ctrl-c. This has removed various bugs when developing locally.
# See here - https://unix.stackexchange.com/a/407249
trap handleInt SIGINT
function handleInt {
  # remove symlink
  rm -rf $ACTIVE_CONFIGURATION/
  # copy back contents
  cp -r $CONFIG_FOLDER/ $ACTIVE_CONFIGURATION/
  # remove config folder contents
  rm -rf $CONFIG_FOLDER/
  printf '\n'
  exit 0
}

if [ ! -d "$ACTIVE_CONFIGURATION" ]; then
  echo Directory $ACTIVE_CONFIGURATION does not exist.
  echo Available options are - 
  ls ./src/configurations
  exit 1
fi

if [ -h "$ACTIVE_CONFIGURATION/routesConfig.ts" ]; then
  if [ ! -z $2 ]; then
    echo 'Removing previous symlink since -r was provided'
    handleInt
  else
    echo "
    Something went wrong: Detected symlink in $ACTIVE_CONFIGURATION
    If you ran ./linkConfig $folderNoSlash last rerun this script like so -
    $ ./linkConfig $folderNoSlash -r
    Then fix the error that caused yarn start to fail (most likely need to clean install node_modules).

    Otherwise to reset the configuration run
    $ git checkout $ACTIVE_CONFIGURATION
    "
    exit 1
  fi
fi

# React applications can’t resolve symlinks, so instead of symlinking the
# configuration to the react app, we copy over the configuration and symlink
# the contents back to the configuration
# clear out config
rm -rf ./$CONFIG_FOLDER/*
# copy over the contents
cp -r ./$ACTIVE_CONFIGURATION/ ./$CONFIG_FOLDER/
rm  -rf ./$ACTIVE_CONFIGURATION/*
# symlink the current directory
cd ./$ACTIVE_CONFIGURATION
ln -s ../../config/* .
cd ../../../
# start the project
# Fixes node binding error when switching between packages and forgetting to run this command...
npm rebuild node-sass
yarn && yarn start