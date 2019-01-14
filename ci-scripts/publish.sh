#! /bin/bash

# publish tagged releases
echo "TRAVIS_COMMIT_MESSAGE $TRAVIS_COMMIT_MESSAGE"
if [[ "$TRAVIS_COMMIT_MESSAGE" =~ chore\(release\):\sversion\s[0-9]+\.[0-9]+\.[0-9]+ ]]; then
    echo "inside if statement"
    npm publish
else
    echo "inside else statement"
    git config --global user.email "fundamental@sap.com"
    git config --global user.name "fundamental-bot"

    git checkout master
    # update the package verion and commit to the git repository
    npm run std-version -- --prerelease rc --no-verify

    # pushes changes to master
    git status
    git push --follow-tags "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG" "$TRAVIS_BRANCH" > /dev/null 2>&1;

    npm publish --tag prerelease
fi
