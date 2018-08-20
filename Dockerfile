FROM ruby:2.5

# https://hub.docker.com/_/ruby/ # Encoding
ENV LANG C.UTF-8

WORKDIR /srv

COPY Gemfile Gemfile.lock /srv/
COPY .ruby-version /srv
RUN bundle install

COPY app    /srv/app
COPY bin    /srv/bin
COPY config /srv/config
COPY db     /srv/db
COPY lib    /srv/lib
COPY public /srv/public
COPY vendor /srv/vendor

COPY Procfile /srv/
COPY Rakefile /srv/

# This file is used by Rack-based servers to start the application.
COPY config.ru /srv/

ENV RAILS_ENV production
ENV RAKE_ENV production