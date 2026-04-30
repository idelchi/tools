#!/bin/bash
# If task doesn't exist in /usr/local/bin, install it
if ! [ -x "$(command -v task)" ]; then
  echo "Installing task..."
  sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b /usr/local/bin
fi
