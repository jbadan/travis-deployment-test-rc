#! /bin/bash
# npm publish for major versions
if [ "$TRAVIS_TAG" =~ '^v[0-9]+\.[0-9]+\.[0-9]+$' ]; then
    npm publish
else
    git config --global user.email "travis@travis.org"
    git config --global user.name "travis"

    git checkout master
    # update the package verion and commit to the git repository
    npm run std-version -- --prerelease rc --no-verify

    # pushes changes to master
    git push --quiet --follow-tags "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG" "$TRAVIS_BRANCH" > /dev/null 2>&1;

    npm publish --tag prerelease
fi
