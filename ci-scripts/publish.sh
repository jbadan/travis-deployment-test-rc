git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis"

# update the package verion and commit to the git repository

npm install

npm run std-version

npm whoami

npm adduser --registry=https://registry.npmjs.org/ <<!
$NPM_USERNAME
$NPM_PASSWORD
$NPM_EMAIL
!

git push --tags origin $TRAVIS_BRANCH

npm publish