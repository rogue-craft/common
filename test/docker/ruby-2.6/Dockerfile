FROM ruby:2.6

RUN mkdir /app
WORKDIR /app

ADD Gemfile /app/
ADD rogue-craft-common.gemspec /app/

RUN bundle install --with test

ADD . /app
