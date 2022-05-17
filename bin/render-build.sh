#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
yarn install
yarn build
bundle exec rake db:migrate
