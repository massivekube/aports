STABLE_PACKAGES=$(wildcard stable/*)
TESTING_PACKAGES=$(wildcard testing/*)

testing: $(TESTING_PACKAGES)

stable: $(STABLE_PACKAGES)

$(STABLE_PACKAGES):
	cd $@ && REPODEST=/tmp/packages abuild -r

$(TESTING_PACKAGES):
	cd $@ && REPODEST=/tmp/packages abuild -r

all: $(STABLE_PACKAGES) $(TESTING_PACKAGES)

shell:
	@docker run --rm -it -v $(shell pwd):/packages -v $(shell pwd)/repo:/tmp/packages --entrypoint=sh -u alpine massiveco/docker-alpine-sdk

docker:
	@docker run --rm -it -v $(shell pwd):/packages -v $(shell pwd)/repo:/tmp/packages --entrypoint=sh -u alpine massiveco/docker-alpine-sdk -c 'cd /packages && make all'

sync:
	rsync -avrz -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --progress /tmp/packages alpine.ma.ssive.co:/var/www/alpine.ma.ssive.co/

.PHONY: all docker sync $(TESTING_PACKAGES) $(STABLE_PACKAGES)