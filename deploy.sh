#!/bin/bash 
set -e
TestEnv="test"
PACKAGE_NAME=$(cat package.json \
  | grep name \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g')


if [ -z "$1" ]; then
npm version patch
fi
if test $1 = $TestEnv 
then
   npm version prerelease
fi

PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g')

git add .
git commit -m "chore: $PACKAGE_NAME-$PACKAGE_VERSION"
git tag "$PACKAGE_NAME-$PACKAGE_VERSION"

git push origin --tags