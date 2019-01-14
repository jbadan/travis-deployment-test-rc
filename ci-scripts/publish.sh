#! /bin/bash

# publish tagged releases
if [[ "$TRAVIS_COMMIT_MESSAGE" =~ chore\(release\):\screate\snew\srelease\svia\sscript ]]; then
    npm run std-version
    git push --follow-tags "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG" "$TRAVIS_BRANCH" > /dev/null 2>&1;
    npm publish
# bump rc and publish
else
    npm --version 
    node --version
    
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
