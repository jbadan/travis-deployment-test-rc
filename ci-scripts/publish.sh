git config --global user.email "jenna.badanowski@gmail.com"
git config --global user.name "jbadan"

# update the package verion and commit to the git repository

npm install

npm run std-version

echo "//<npm-registry>:8080/:_authToken=$AUTH_TOKEN" > ~/.npmrc

# npm adduser --registry=https://registry.npmjs.org/ <<!
# "jbadan"
# $NPM_PASSWORD
# "jenna.badanowski@gmail.com"
# !

git push --tags origin $TRAVIS_BRANCH

npm publish