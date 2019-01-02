git config --global user.email "jenna.badanowski@gmail.com"
git config --global user.name "jbadan"

# update the package verion and commit to the git repository

echo "made it here"

npm run std-version

git push --tags origin $TRAVIS_BRANCH

npm publish