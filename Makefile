NAME = jstclair/docker-hellomvc-no-mono
RUNTIME = dnx-coreclr-linux-x64.1.0.0-beta8-15604
PORT = 5004
CONFIG = Release

default: all

all: clean restore build publish docker-build
	
clean: 
	rm -rf ./publish && rm -rf ./bin

restore:
	dnu restore .

build: 
	dnu build --configuration $(CONFIG)

nodemon: 
	nodemon --ext "cs,json" --exec "dnx kestrel"

watch: restore nodemon

publish:
	echo $(RUNTIME)
	dnu publish . --no-source --runtime $(RUNTIME)

docker-build:
	docker build -t $(NAME) .

push:
	docker push $(NAME)

debug:
	docker run --entrypoint=/bin/bash --rm -it -p $(PORT):$(PORT) $(NAME)

run:
	docker run --rm -it -p $(PORT):$(PORT) $(NAME)
	
run-d:
	docker run -d -p $(PORT):$(PORT) $(NAME)
	
release: build push
