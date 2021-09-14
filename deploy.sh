#!/bin/bash 
set -e
TestEnv="test"
PACKAGE_NAME=$(cat package.json \
  | grep name \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

npm run build
if [ -z "$1" ]; then
npm version patch -git-tag-version false
else test $1 = $TestEnv 
   npm version prerelease --preid=alpha -git-tag-version false
fi

PACKAGE_VERSION=$(cat package.json \
  | grep version \
  | head -1 \
  | awk -F: '{ print $2 }' \
  | sed 's/[",]//g' \
  | tr -d '[[:space:]]')

npm publish
git add .
git commit -m "Chore: Upgrade to $PACKAGE_VERSION"
git tag "$PACKAGE_NAME-$PACKAGE_VERSION"
git push origin --tags