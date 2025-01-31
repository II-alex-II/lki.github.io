#!/usr/bin/env bash

set -e

echo "Checking if need to rebuild site."

hugo --quiet
cp public/index.xml public/feed.xml

if [[ -d public/.git ]]; then
  git -C public fetch --quiet
  git -C public reset --soft origin/master
else
  rm -rf .deploy
  git clone -n -b master git@github.com:LKI/lki.github.io.git .deploy
  mv .deploy/.git public
fi

if [[ "$(git -C public status)" =~ "nothing to commit" ]]; then
  echo "Already latest."
else
  git -C public fetch origin
  git -C public reset --soft origin/dev
  git -C public add .
  git -C public commit -m "chore: auto build from hugo"
  git -C public push -u origin master -f
fi
