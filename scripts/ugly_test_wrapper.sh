#!/bin/bash

if [ -z "$TRAVIS_BUILD_DIR" ]; then
  echo "Warning: the env variable TRAVIS_BUILD_DIR is not defined"
fi

cd "$TRAVIS_BUILD_DIR"
echo "Running tests"
npm test > out.txt 2>&1
cat out.txt
grep -iEq "npm ERR! Test failed|error: Unable to find" out.txt
if [ $? = 0 ]; then
  echo "Tests failed."
  code=1
else
  echo "Test passed"
  code=0
fi

rm out.txt
exit $code
