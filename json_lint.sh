#!/bin/sh
# vim: tabstop=4 shiftwidth=4 smarttab expandtab softtabstop=4 autoindent

cat "$1" | jaq > /dev/null || {
    echo "Error with: $1"
    exit 1
}
