#! /bin/bash

git config --global user.email "travis@travis.org"
git config --global user.name "travis"

git checkout develop
npm install
# update the package verion and commit to the develop branch
npm run std-version -- --prerelease rc --no-verify

# pushes changes to correct HEAD
. ci-scripts/travis_branch.sh

travis-branch-commit

npm publish --tag prerelease