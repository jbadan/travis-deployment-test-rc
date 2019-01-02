git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis"

# update the package verion and commit to the git repository

npm install

npm run std-version

git push --tags origin $TRAVIS_BRANCH

npm publish