#!/bin/bash

failed="false"

bundle exec rubocop
if [ "$?" -eq "0" ]; then
  failed="true"
fi

bundle exec rspec
if [ "$?" -eq "0" ]; then
  failed="true"
fi

if [ $failed = "true" ]; then
  echo "Build failed!"
  exit 1
fi
