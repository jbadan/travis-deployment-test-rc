#! /bin/bash
. ci-scripts/travis_branch.sh

git config --global user.email "travis@travis.org"
git config --global user.name "travis"

git checkout master
npm install
# update the package verion and commit to the git repository
npm run std-version

# pushes changes to correct HEAD
travis-branch-commit

npm publish