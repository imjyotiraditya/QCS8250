#!/usr/bin/env bash

qssi="qssi.xml"
kernel="kernel.xml"
vendor="vendor.xml"
output="target.xml"

# Remove the output file
rm -f "$output"

# Extract content between <manifest> tags and merge them
{
    echo '<?xml version="1.0" encoding="UTF-8"?>'
    echo "<manifest>"
    xmlstarlet sel -t -c "//manifest/node()" "$qssi"
    xmlstarlet sel -t -c "//manifest/node()" "$kernel"
    xmlstarlet sel -t -c "//manifest/node()" "$vendor"
    echo "</manifest>"
} | xmlstarlet fo | xmlstarlet ed \
    -d "//manifest/remote[position() > 1]" \
    -d "//manifest/default[position() > 1]" \
    -d "//manifest/refs" \
    -d "//manifest/project/@remote" \
    -i "//manifest/default" -t attr -n "sync-c" -v "true" \
    -i "//manifest/default" -t attr -n "sync-tags" -v "false" \
    > "$output"
