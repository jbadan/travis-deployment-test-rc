#! /bin/bash
NOCOLOR='\033[0m'
ERROR='\033[31m'

git fetch

# make sure we're on a releasable branch
git_branch=$(git rev-parse --abbrev-ref HEAD)
master=$(echo $git_branch | grep -cE "^master$")
archive=$(echo $git_branch | grep -cE "^archive\-v\d+$")
[[ "$master" = "0" && "$archive" = "0" ]] && echo -e "\n\t${ERROR}Sorry, this branch cannot be released.${NOCOLOR}\n\tReleases can only be published from 'master' and 'archive-v#' branches.\n\n" && exit 0

# make sure the current branch is a release candidate
rcVersion=$(grep '\"version\":' package.json | grep -c "\-rc.")
[ "$rcVersion" = "0" ] && echo -e "\n\t${ERROR}Sorry, this branch is not a release candidate.${NOCOLOR}\n\tIn order to publish a release, the package must be an 'rc' version.\n\n" && exit 0

# make sure the branch is clean
git_status=$(git status --porcelain)
[ -n "$git_status" ] && echo -e "\n\t${ERROR}Sorry, you have uncommitted changes.${NOCOLOR}\n\tIn order to publish a release, your working directory must be clean.\n\n" && exit 0

# make sure the branch is up-to-date
hash_head=$(git rev-parse HEAD)
hash_upstream=$(git rev-parse $git_branch@{upstream})
[ "$hash_head" != "$hash_upstream" ] && echo -e "\n\t${ERROR}Sorry, the branch is out of date.${NOCOLOR}\n\tIn order to publish a release, the branch must match the origin.\n\n" && exit 0

set -o errexit

git checkout -b automated_master_release
git commit --allow-empty -m "chore(release): create new release via script"
git push --set-upstream origin automated_master_release
git checkout master
# delete branch on local and remote
git push origin :automated_master_release
git branch -D automated_master_release