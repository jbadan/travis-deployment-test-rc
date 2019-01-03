git config --global user.email "travis@travis.org"
git config --global user.name "travis"

# update the package verion and commit to the git repository

npm install

npm run std-version

echo "//registry.npmjs.org/:_password=${NPM_PASSWORD}" > ~/.npmrc
echo "//registry.npmjs.org/:_authToken=${AUTH_TOKEN}" >> ~/.npmrc
echo "//registry.npmjs.org/:username=jbadan" >> ~/.npmrc
echo "//registry.npmjs.org/:email=jenna.badanowski@gmail.com" >> ~/.npmrc

git remote add origin "https://${GH_TOKEN}@github.com/jbadan/tavis-deployment-test.git"

git push --tags origin ${TRAVIS_BRANCH}

npm publish