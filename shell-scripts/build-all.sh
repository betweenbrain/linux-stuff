#!/bin/bash

echo "Executing pull-all.sh"
. pull-all.sh

echo
echo "# # # # # # # #"
echo

echo "Traversing into Construct5 2-5"
cd ../construct5
git status
echo "Enter complete release number (i.e. 2.5.6):"
read release_number
git tag $release_number
git archive $release_number -o ../../../RELEASES/Construct5-$release_number.zip

echo
echo "# # # # # # # #"
echo

echo "Traversing into Construct5 Core 2-5"
cd ../construct5-core
git status
echo "Enter release date (i.e. 1-13-2013):"
read release_number
git tag $release_number
git archive $release_number -o ../../../RELEASES/Construct5-Core-$release_number.zip

echo
echo "# # # # # # # #"
echo

echo "Traversing into Construct5 Pro 2-5"
cd ../construct5-pro
git status
echo "Enter complete release number (i.e. 1.6.666):"
read release_number
git tag $release_number
git archive $release_number -o ../../../RELEASES/Construct5-Pro-$release_number.zip

echo
echo "# # # # # # # #"
echo

echo "Traversing into Construct Community 2-5"
cd ../je-construct-community
git status
echo "Enter complete release number (i.e. 2.5.666):"
read release_number
git tag $release_number
git archive $release_number -o ../../../RELEASES/Construct-Community-$release_number.zip

echo
echo "# # # # # # # #"
echo

echo "Traversing into Construct Pro 2-5"
cd ../je-construct-pro
git status
echo "Enter complete release number (i.e. 2.5.666):"
read release_number
git tag $release_number
git archive $release_number -o ../../../RELEASES/Construct-Pro-$release_number.zip

