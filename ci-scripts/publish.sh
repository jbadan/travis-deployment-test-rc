git config --global user.email "jenna.badanowski@gmail.com"
git config --global user.name "jbadan"

# update the package verion and commit to the git repository

npm install

npm run std-version

npm whoami

echo -e "jbadan\n$NPM_PASSWORD\njenna.badanowski@gmail.com" | npm login

# npm adduser --registry=https://registry.npmjs.org/ <<!
# $NPM_USERNAME
# $NPM_PASSWORD
# $NPM_EMAIL
# !

git push --tags origin $TRAVIS_BRANCH

npm publish