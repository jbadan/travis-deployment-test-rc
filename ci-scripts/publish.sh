git config --global user.email "travis@travis.org"
git config --global user.name "travis"

# update the package verion and commit to the git repository

npm install

npm run std-version

echo "//registry.npmjs.org/:_password=${NPM_PASSWORD}" > ~/.npmrc
echo "//registry.npmjs.org/:_authToken=${AUTH_TOKEN}" >> ~/.npmrc
echo "//registry.npmjs.org/:username=jbadan" >> ~/.npmrc
echo "//registry.npmjs.org/:email=jenna.badanowski@gmail.com" >> ~/.npmrc

echo ${TRAVIS_BRANCH}

git push --force "https://${GITHUB_TOKEN}@$github.com/jbadan/travis-deployment-test.git" --tags  master > /dev/null 2>&1

# git push "https://${GH_TOKEN}@github.com/jbadan/travis-deployment-test" --tags origin ${TRAVIS_BRANCH}

npm publish