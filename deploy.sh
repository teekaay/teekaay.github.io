#!/bin/sh

echo "Deploying"

hugo
git checkout master
rm -rf about blog categories code colophon content css fixed img tags
rm 404.html index.html sitemap.xml index.xml
mv public/* ./
rm -rf public
git add .
git commit -m 'Update website'
git push origin master
git checkout content

