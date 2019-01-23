#! /bin/bash

# publish tagged releases

git config --global user.email "fundamental@sap.com"
git config --global user.name "fundamental-bot"

git checkout master
npm install

if [[ "$TRAVIS_BRANCH" = "automated_master_release" ]]; then
    echo "inside if statement"
    npm run std-version
    git push --follow-tags "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG" master > /dev/null 2>&1;
  
    npm publish

    # delete automated_master_release branch
    git push "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG" :automated_master_release > /dev/null 2>&1;
# bump and publish rc
else
    echo "inside else statement"

    # update the package verion and commit to the git repository
    npm run std-version -- --prerelease rc --no-verify

    # pushes changes to master
    git status
    git push --follow-tags "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG" "$TRAVIS_BRANCH" > /dev/null 2>&1;

    npm publish --tag prerelease
fi
