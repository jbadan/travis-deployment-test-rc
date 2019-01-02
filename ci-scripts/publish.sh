git config --global user.email "jenna.badanowski@gmail.com"
git config --global user.name "jbadan"

# update the package verion and commit to the git repository

npm install

npm run std-version

npm whoami

echo -e "$NPM_USERNAME\n$NPM_PASSWORD\n$NPM_EMAIL" | npm login

# npm adduser --registry=https://registry.npmjs.org/ <<!
# $NPM_USERNAME
# $NPM_PASSWORD
# $NPM_EMAIL
# !

git push --tags origin $TRAVIS_BRANCH

npm publish