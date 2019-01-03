#! /bin/bash
. ci-scripts/travis_branch.sh

git config --global user.email "travis@travis.org"
git config --global user.name "travis"

git checkout master
npm install
#bump version in package.json, update CHANGELOG.md &  package-lock.json; git add and git commit
npm run std-version

# pushes changes to correct HEAD
travis-branch-commit

npm publish