#!/usr/bin/env bash

# Determine the "default" branch
ORIGIN=$(git remote show | head -n 1)
LOG_PREFIX="Merge conflicts hook -"

if [[ -n "$ORIGIN" ]]
then
  echo "$LOG_PREFIX Origin is '$ORIGIN'"
  DEFAULT_BRANCH=$(git remote show "$(git remote show | head -n 1)" | sed -n '/HEAD branch/s/.*: //p')
else
  # Fallback logic in case no remote is present, unlikely though?
  BRANCHES=$(git branch --list)
  for b in "master" "main"
  do
    if grep -q "$b" <<< "$BRANCHES"
    then
      DEFAULT_BRANCH=$b
    fi
    break
  done
fi

if [[ -z "$DEFAULT_BRANCH" ]]
then
  echo "$LOG_PREFIX Could not determine default branch, exiting without checking for conflicts"
  exit 0
fi

echo "$LOG_PREFIX Default branch is '$DEFAULT_BRANCH'"

if [[ -n "$ORIGIN" ]]
then
  # Pull the default branch from remote
  git fetch --quiet origin "$DEFAULT_BRANCH":"$DEFAULT_BRANCH"
fi

# Check for merge conflicts and abort
MERGE_RESULT=$(git merge-tree --write-tree "$(git rev-parse --abbrev-ref HEAD)" "$DEFAULT_BRANCH")
if [ $? -eq 0 ]
then
  # Able to merge without conflicts
  echo "$LOG_PREFIX Good to merge!"
  exit 0
else
  echo "$LOG_PREFIX $(echo "$MERGE_RESULT"  | tail -n 1 | cut -d':' -f 2)"
  exit 1
fi
