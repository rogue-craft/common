test-docker-ruby-2.6:
	docker build -f test/docker/ruby-2.6/Dockerfile -t rogue-craft-common-ruby-2.6  . \
	&& docker run --rm rogue-craft-common-ruby-2.6 /bin/sh -c "bundle && GENERATE_COVERAGE=1 bundle exec rake test"

test-docker-ruby-2.7:
	docker build -f test/docker/ruby-2.7/Dockerfile -t rogue-craft-common-ruby-2.7  . \
	&& docker run --rm rogue-craft-common-ruby-2.7 /bin/sh -c "bundle && GENERATE_COVERAGE=1 bundle exec rake test"
