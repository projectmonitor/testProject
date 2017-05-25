#!/usr/bin/env bash

set -euf -o pipefail

# REPLACE ME WITH YOUR ORG AND SPACE
export CF_SPACE=example_space
export CF_ORG=example_org

# because of how Jenkins checks out from Git, we are not on a branch and the remote branches are not known locally
git checkout master
git branch -va

if [[ "$ShaToBuild" == "0" ]] ; then
  echo "Cannot build from SHA: $ShaToBuild"
  exit 1
fi

ShaToBuild=$(git rev-parse $ShaToBuild)
echo "Building SHA $ShaToBuild"

git checkout $ShaToBuild

mvn clean package -DskipTests

./ci/add_story_to_manifest.sh manifest-acceptance.yml ${ShaToBuild} ${STORY_ID}

cf login -a api.run.pivotal.io -u ${CF_USER} -p ${CF_PASSWORD} -s $CF_SPACE -o $CF_ORG
cf push -f manifest.yml -t 180
cf logout

git checkout master