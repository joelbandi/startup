#!/bin/bash
set -e

bundle exec rails log:clear tmp:clear
bundle exec rails db:prepare 

exec "$@"
