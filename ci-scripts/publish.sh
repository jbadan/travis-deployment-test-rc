git config --global user.email "travis@travis-ci.org"
git config --global user.name "Travis"

# update the package verion and commit to the git repository

npm install

npm run std-version

echo $NPM_USERNAME
echo $NPM_PASSWORD
echo $NPM_EMAIL

npm adduser --registry=https://registry.npmjs.org/ << !
$NPM_USERNAME
$NPM_PASSWORD
$NPM_EMAIL
!

git push --tags origin $TRAVIS_BRANCH

npm publish