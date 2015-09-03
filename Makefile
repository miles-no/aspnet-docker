NAME = jstclair/docker-hellomvc-no-mono
RUNTIME = dnx-coreclr-linux-x64.1.0.0-beta7
PORT = 5004
CONFIG = Release

default: all

all: clean restore build publish docker-build
	
clean: 
	rm -rf publish
	rm -rf bin

restore:
	dnu restore .

build: 
	dnu build

publish:
	dnu publish . --no-source --runtime $(RUNTIME) --configuration $(CONFIG)

docker-build:
	docker build -t $(NAME) .

push:
	docker push $(NAME)

debug:
	docker run --rm -it -p $(PORT):$(PORT) --entrypoint=/bin/bash $(NAME)

run:
	docker run --rm -it -p $(PORT):$(PORT) $(NAME)
	
run-d:
	docker run --rm -d -p $(PORT):$(PORT) $(NAME)
	
release: build push
