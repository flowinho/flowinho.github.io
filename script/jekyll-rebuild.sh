#!/bin/bash

# skip if build is triggered by pull request
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

echo "Commit and push"
git add -A .
git commit -m "rebuild pages" --allow-empty
git status
git push origin master