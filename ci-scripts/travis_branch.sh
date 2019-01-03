# function to make a commit on a branch in a Travis CI build
# see https://github.com/travis-ci/travis-ci/issues/1701
# modified from https://gist.github.com/ddgenome/f3a60fe4c2af0cbe758556d982fbeea9

function travis-branch-commit() {
    local head_ref branch_ref
    head_ref=$(git rev-parse HEAD)
    if [[ $? -ne 0 || ! $head_ref ]]; then
        err "failed to get HEAD reference"
        return 1
    fi
    branch_ref=$(git rev-parse "$TRAVIS_BRANCH")
    if [[ $? -ne 0 || ! $branch_ref ]]; then
        err "failed to get $TRAVIS_BRANCH reference"
        return 1
    fi
    if [[ $head_ref != $branch_ref ]]; then
        msg "HEAD ref ($head_ref) does not match $TRAVIS_BRANCH ref ($branch_ref)"
        msg "someone may have pushed new commits before this build cloned the repo"
        return 0
    fi
    if ! git checkout "$TRAVIS_BRANCH"; then
        err "failed to checkout $TRAVIS_BRANCH"
        return 1
    fi

    local remote=origin
    if [[ $GH_TOKEN ]]; then
        remote=https://$GH_TOKEN@github.com/$TRAVIS_REPO_SLUG
    fi
    if [[ $TRAVIS_BRANCH != master || $TRAVIS_BRANCH != develop ]]; then
        msg "not pushing updates to branch $TRAVIS_BRANCH"
        return 0
    fi
    if ! git push --quiet --follow-tags "$remote" "$TRAVIS_BRANCH" > /dev/null 2>&1; then
        err "failed to push git changes"
        return 1
    fi
}
function msg() {
    echo "travis-commit: $*"
}
function err() {
    msg "$*" 1>&2
}
