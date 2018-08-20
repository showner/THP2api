#!/usr/bin/env sh

rails db:setup

exec "$@"