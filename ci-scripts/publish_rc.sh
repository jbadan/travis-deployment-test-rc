#git config --global user.email "EMAIL HERE"
#git config --global user.name "USERNAME HERE"

# update the package verion and commit to the git repository
npm install
npm run std-version -- --prerelease rc --no-verify
git push --follow-tags origin ${CIRCLE_BRANCH}
npm publish --tag prerelease