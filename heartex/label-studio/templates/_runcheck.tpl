#!/bin/sh

set -e

notify() {
  echo "$1"
  echo -n "$1 " >>/dev/termination-log
}

greater_version()
{
  test "$(printf '%s\n' "$@" | sort -V | tail -n 1)" = "$1";
}

#TODO add check for opensource/enterprise types
LS_MIN_VERSION=
CHART_MIN_VERSION=0.0.49

# Only run check for semver(-hotfix) releases
if ! awk 'BEGIN{exit(!(ARGV[1] ~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}(([0-9]+)?)/))}' "$LS_VERSION"; then
  exit 0
fi

LS_VERSION_NO_SUFFIX=$(echo $LS_VERSION | cut -d'-' -f1)
NEW_MAJOR_VERSION=$(echo $LS_VERSION_NO_SUFFIX | awk -F "." '{print $1}')
NEW_MINOR_VERSION=$(echo $LS_VERSION_NO_SUFFIX | awk -F "." '{print $1"."$2}')

NEW_CHART_MAJOR_VERSION=$(echo $CHART_VERSION | awk -F "." '{print $1}')
NEW_CHART_MINOR_VERSION=$(echo $CHART_VERSION | awk -F "." '{print $1"."$2}')

OLD_VERSION_STRING=$(cat /chart-info/LSVersion)
OLD_CHART_VERSION_STRING=$(cat /chart-info/LSChartVersion)

# Skip check if old version wasn't semver(-hotfix)
if ! awk 'BEGIN{exit(!(ARGV[1] ~ /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}((\-hotfix\.[0-9]+)?)/))}' "$OLD_VERSION_STRING"; then
  exit 0
fi

OLD_VERSION_NO_SUFFIX=$(echo $LS_VERSION | cut -d'-' -f1)
OLD_MAJOR_VERSION=$(echo $OLD_VERSION_NO_SUFFIX | awk -F "." '{print $1}')
OLD_MINOR_VERSION=$(echo $OLD_VERSION_NO_SUFFIX | awk -F "." '{print $1"."$2}')
OLD_CHART_MAJOR_VERSION=$(echo $OLD_CHART_VERSION_STRING | awk -F "." '{print $1}')
OLD_CHART_MINOR_VERSION=$(echo $OLD_CHART_VERSION_STRING | awk -F "." '{print $1"."$2}')

# Checking Version
# (i) if it is a major version jump
# (ii) if existing version is less than required minimum version
if [ ${OLD_MAJOR_VERSION} -lt ${NEW_MAJOR_VERSION} ] || [ ${OLD_CHART_MAJOR_VERSION} -lt ${NEW_CHART_MAJOR_VERSION} ]; then
  if (! greater_version $OLD_MINOR_VERSION $MIN_VERSION) || (! greater_version $OLD_CHART_MINOR_VERSION $CHART_MIN_VERSION); then
    notify "It seems you are upgrading the Label Studio Helm Chart from ${OLD_CHART_VERSION_STRING} (Label Studio ${OLD_VERSION_STRING}) to ${CHART_VERSION} (Label Studio Enterprise ${LS_VERSION})."
    notify "It is required to upgrade to the latest ${CHART_MIN_VERSION} version first before proceeding."
    notify "Please follow the upgrade documentation at https://labelstud.io/guide/heartex/releases/1_0.html"
    notify "and upgrade to Label Studio Helm Chart version ${CHART_MIN_VERSION} before upgrading to ${CHART_VERSION}."
    exit 1
  fi
fi
