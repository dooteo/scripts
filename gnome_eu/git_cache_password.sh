#!/bin/bash

echo "Set git to use the credential memory cache"
git config --global credential.helper cache

SECONDS=7200
echo "Set the cache to timeout after 2 hour (setting is in seconds)"
git config --global credential.helper 'cache --timeout='${SECONDS}''
