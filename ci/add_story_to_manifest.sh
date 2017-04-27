#!/usr/bin/env bash

MANIFEST_TO_MODIFY=$1
REVISION_SHA=$2
STORY_ID=$3

#awk -v REVISION_SHA=${REVISION_SHA} '/^    storySha:/{ $0 = "    storySha: " REVISION_SHA }{print}' ${MANIFEST_TO_MODIFY} > manifest.yml

line_number=$(cat -n manifest-acceptance.yml | grep storySha | awk '{print $1}')
sed "${line_number}s/.*/    storySha: ${REVISION_SHA}/" manifest-acceptance.yml > manifesttemp.yml

line_number=$(cat -n manifest.yml | grep pivotalTrackerStoryID | awk '{print $1}')
sed "${line_number}s/.*/    pivotalTrackerStoryID: ${STORY_ID}/" manifesttemp.yml > manifest.yml

rm manifesttemp.yml
cat manifest.yml

