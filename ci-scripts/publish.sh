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
git checkout develop
git merge master

git commit -a -m "merge master into develop [ci skip]"

git push --quiet --follow-tags "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG" develop > /dev/null 2>&1;

npm publish