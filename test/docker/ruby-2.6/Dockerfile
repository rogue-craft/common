FROM ruby:2.6

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/
COPY rogue-craft-common.gemspec /app/

RUN gem install bundle

COPY . /app
