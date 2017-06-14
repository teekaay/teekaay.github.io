#!/bin/sh

echo "Deploying"

hugo
git branch -D master
git checkout -b master
mv public/* ./
rm -rf public
git add .
git commit -m 'Update website'
git push origin master
git checkout content
