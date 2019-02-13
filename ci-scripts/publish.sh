#! /bin/bash

# publish tagged releases

git config --global user.email "fundamental@sap.com"
git config --global user.name "fundamental-bot"

git checkout master
npm install

if [[ "$TRAVIS_BRANCH" = "tmp_branch_for_automated_release_do_not_use" ]]; then
    echo "inside if statement"
    # delete tmp_branch_for_automated_release_do_not_use branch
    git push "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG" :tmp_branch_for_automated_release_do_not_use > /dev/null 2>&1;

    std_ver=$(npm run std-version)
    release_tag=$(echo "$std_ver" | grep "tagging release" | awk '{print $4}')

    echo "$std_ver"

    git push --follow-tags "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG" master > /dev/null 2>&1;
  
    npm run release:create -- --tag $release_tag --debug

    npm publish

else
    # bump and publish rc
    echo "inside else statement"

    # update the package verion and commit to the git repository
    npm run std-version -- --prerelease rc --no-verify

    # pushes changes to master
    git status
    git push --follow-tags "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG" "$TRAVIS_BRANCH" > /dev/null 2>&1;

    npm publish --tag prerelease

    npm run deploy -- --repo "https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG"
fi
