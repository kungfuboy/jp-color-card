#!/usr/bin/env sh

cd dist/
git init .
git add .
git commit -m'deploy'
git push -f https://github.com/kungfuboy/jp-color-card.git master:gh-pages
cd -