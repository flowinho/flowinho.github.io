#!/bin/bash

# skip if build is triggered by pull request
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "this is PR, exiting"
  exit 0
fi

# enable error reporting to the console
set -e

echo "Commit and push"
git commit --allow-empty -m "Travis CI"
git push "https://$GH_TOKEN@github.com/flowinho/flowinho.github.io" HEAD:master