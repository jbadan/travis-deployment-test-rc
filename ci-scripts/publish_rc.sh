#! /bin/bash
. ci-scripts/travis_branch.sh

git config --global user.email "travis@travis.org"
git config --global user.name "travis"

git checkout develop
npm install
# update the package verion and commit to the git repository
npm run std-version -- --prerelease rc --no-verify

# pushes changes to correct HEAD
travis-branch-commit

npm publish --tag prerelease