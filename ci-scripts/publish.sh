#! /bin/bash
. ci-scripts/travis_branch.sh
# configure username and email for Travis
git config --global user.email "travis@travis.org"
git config --global user.name "travis"

git checkout master
npm install
#bump version in package.json, changelog; git add and git commit
npm run std-version

# pushes changes to correct HEAD
travis-branch-commit

npm publish