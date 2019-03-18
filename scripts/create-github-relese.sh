#!/bin/bash

if grep "SNAPSHOT" version.txt; then
    printf 'Not on release branch. Stopping.\n' >&2
    exit 1
fi

if [ -z "${GITHUB_TOKEN}" ]; then
    printf 'GITHUB_TOKEN environment variable not set. Stopping.\n' >&2
    exit 1;
fi


TARGET_REPO="julianghionoiu/tdl-runner-python"

RELEASE_VERSION=`cat version.txt`
TAG_NAME="v${RELEASE_VERSION}"
POST_DATA=`printf '{
  "tag_name": "%s",
  "target_commitish": "master",
  "name": "%s",
  "body": "Release %s",
  "draft": false,
  "prerelease": false
}' ${TAG_NAME} ${TAG_NAME} ${TAG_NAME}`
echo "Creating release ${RELEASE_VERSION}: $POST_DATA"
curl \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Content-Type: application/json" \
    -H "Accept: application/vnd.github.v3+json" \
    -X POST -d "${POST_DATA}" "https://api.github.com/repos/${TARGET_REPO}/releases"


CURL_OUTPUT="./build/github-release.listing"
echo "Getting Github ReleaseId"
curl \
    -H "Authorization: token ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github.v3+json" \
    -X GET "https://api.github.com/repos/${TARGET_REPO}/releases/tags/${TAG_NAME}" |
    tee ./build/github-release.listing
RELEASE_ID=`cat ${CURL_OUTPUT} | grep id | head -n 1 | tr -d " " | tr "," ":" | cut -d ":" -f 2`

function uploadAsset() {
    local releaseId=$1
    local assetName=$2
    local releaseJar="./build/libs/${assetName}"
    echo "Uploading asset to ReleaseId ${releaseId}, name=${assetName}"
    curl \
        -H "Authorization: token ${GITHUB_TOKEN}" \
        -H "Content-Type: application/zip" \
        -H "Accept: application/vnd.github.v3+json" \
        --data-binary @${releaseJar} \
         "https://uploads.github.com/repos/${TARGET_REPO}/releases/${releaseId}/assets?name=${assetName}"

}

#uploadAsset ${RELEASE_ID} "something"