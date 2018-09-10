#!/usr/bin/env sh

rails db:create db:migrate db:schema:load

exec "$@"