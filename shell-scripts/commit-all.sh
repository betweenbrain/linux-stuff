#!/bin/bash
echo "Enter commit message:"
read commit_message

echo "Traversing into Construct5 2.5"
cd construct5

git add -A
git commit -m "$commit_message"
git push --tags

echo
echo "# # # # # # # #"
echo

echo "Traversing into Construct5 Core 2.5"
cd ../construct5-core

git add -A
git commit -m "$commit_message"
git push origin 2-5 --tags

echo
echo "# # # # # # # #"
echo

echo "Traversing into Construct5 Pro 2.5"
cd ../construct5-pro

git add -A
git commit -m "$commit_message"
git push --tags

echo
echo "# # # # # # # #"
echo

echo "Traversing into Construct Community 2.5"
cd ../je-construct-community

git add -A
git commit -m "$commit_message"
git push origin 2-5 --tags

echo
echo "# # # # # # # #"
echo

echo "Traversing into Construct Pro 2.5"
cd ../je-construct-pro

git add -A
git commit -m "$commit_message"
git push origin 2-5 --tags

