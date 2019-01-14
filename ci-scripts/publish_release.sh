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

#https://gist.github.com/devongovett/10399980
pull_request() {
  to_branch="master"
  # try the upstream branch if possible, otherwise origin will do
  upstream=$(git config --get remote.upstream.url)
  origin=$(git config --get remote.origin.url)
  if [ -z $upstream ]; then
    upstream=$origin
  fi

  echo "upstream $upstream"
  
  to_user=$(echo $upstream | sed -e 's/.*[\/:]\([^/]*\)\/[^/]*$/\1/')
  echo "to_user $to_user"
  from_user=$(echo $origin | sed -e 's/.*[\/:]\([^/]*\)\/[^/]*$/\1/')
  echo "from_user $from_user"
  repo=$(basename `git rev-parse --show-toplevel`)
  echo "repo $repo"
  from_branch=$(git rev-parse --abbrev-ref HEAD)
  echo "from_branch $from_branch"
  open "https://github.com/$to_user/$repo/pull/new/$to_user:$to_branch...$from_user:$from_branch"
}

set -o errexit

git checkout -b chore/create-release
git commit --allow-empty -m "chore(release): create new release via script"
pull_request