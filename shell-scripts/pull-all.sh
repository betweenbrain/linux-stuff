#!/bin/bash

echo "Traversing into Construct5 2.5"
cd construct5

git pull

echo
echo "# # # # # # # #"
echo

echo "Traversing into Construct5 Core 2.5"
cd ../construct5-core

git pull origin 2-5

echo
echo "# # # # # # # #"
echo

echo "Traversing into Construct5 Pro 2.5"
cd ../construct5-pro

git pull

echo
echo "# # # # # # # #"
echo

echo "Traversing into Construct Community 2.5"
cd ../je-construct-community

git pull origin 2-5

echo
echo "# # # # # # # #"
echo

echo "Traversing into Construct Pro 2.5"
cd ../je-construct-pro

git pull origin 2-5

