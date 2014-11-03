#!/usr/bin/env bash

scriptDir="$( cd "$( dirname "$0" )" && pwd )"
source "${scriptDir}/ruby_vars.sh"

rubyVersion="$1"
echo "url: $rubyUrl"
echo "version: $rubyVersion"

wget --no-check-certificate "${rubyUrl}/ruby-${rubyVersion}${rubyExt}"
