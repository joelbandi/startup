#!/bin/bash
set -e

if [[ -z "$SIDEKIQ_INSTANCE" ]]; then
    bundle exec rails log:clear tmp:clear
    bundle exec rails db:prepare 
fi

exec "$@"
