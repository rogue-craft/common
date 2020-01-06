CI_ENV=$(shell curl -s https://codecov.io/env | bash)

test-docker-ruby-2.6:
	docker build -f test/docker/ruby-2.6/Dockerfile -t rogue-craft-common-ruby-2.6  . \
	&& docker run ${CI_ENV} --rm rogue-craft-common-ruby-2.6 \
	/bin/sh -c "bundle && GENERATE_COVERAGE=1 bundle exec rake test"

test-docker-ruby-2.7:
	docker build -f test/docker/ruby-2.7/Dockerfile -t rogue-craft-common-ruby-2.7  . \
	&& docker run ${CI_ENV} --rm rogue-craft-common-ruby-2.7 \
	/bin/sh -c "bundle && GENERATE_COVERAGE=1 bundle exec rake test"
