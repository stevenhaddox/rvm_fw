#!/usr/bin/env bash

scriptDir="$( cd "$( dirname "$0" )" && pwd )"
source "${scriptDir}/ruby_vars.sh"

curl -s "${rubyUrl}/" \
| grep "<a href=\".*ruby-.*\.tar\.bz2" \
| sed -e 's/<a .*href=['"'"'"]//' -e 's/["'"'"'].*$//' -e '/^$/ d' \
| sed -n 's/\.tar\.bz2//p' 
