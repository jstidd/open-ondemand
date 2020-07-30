#!/bin/sh
echo "===================================="
echo "===================================="
echo "ruby and node are running now"
echo "===================================="
echo "===================================="
# Enable nodejs10
scl enable ondemand bash
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start ruby and node: $status"
  exit $status
fi