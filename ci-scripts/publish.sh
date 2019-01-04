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

# commit CHANGELOG and package bump to develop branch
# git commit -m $1

CHERRYCOMMIT=`git log -n1 | head -n1 | cut -c8-`
git stash;
git checkout develop;
git cherry-pick $CHERRYCOMMIT;
git checkout master;
git stash pop;

npm publish