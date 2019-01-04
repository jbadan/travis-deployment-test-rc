#! /bin/bash
# . ci-scripts/travis_branch.sh

git config --global user.email "travis@travis.org"
git config --global user.name "travis"

git checkout master
npm install
# update the package verion and commit to the git repository
npm run std-version

# pushes changes to correct HEAD
# travis-branch-commit

git push --quiet --follow-tags "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG" "$TRAVIS_BRANCH" > /dev/null 2>&1;

# commit CHANGELOG and package bump to develop branch
git checkout develop
git merge master
git commit -a -m "chore: merge master into develop [ci skip]"
git push --quiet --follow-tags "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG" develop > /dev/null 2>&1;

# publish master to npm
git checkout master
npm publish