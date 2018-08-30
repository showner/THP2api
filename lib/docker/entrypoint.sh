#!/usr/bin/env sh

rails db:create db:migrate

exec "$@"