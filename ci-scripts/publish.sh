#! /bin/bash

# publish tagged releases
if [[ "$TRAVIS_COMMIT_MESSAGE" =~ chore\(release\):\sversion\s[0-9]+\.[0-9]+\.[0-9]+$.* ]]; then
    npm publish
# bump rc and publish
else
    git config --global user.email "travis@travis.org"
    git config --global user.name "travis"

    git checkout master
    # update the package verion and commit to the git repository
    npm run std-version -- --prerelease rc --no-verify

    # pushes changes to master
    echo "$TRAVIS_BRANCH"
    git status
    git push --follow-tags "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG" "$TRAVIS_BRANCH" > /dev/null 2>&1;

    npm publish --tag prerelease
fi
