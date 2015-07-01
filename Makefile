NAME = jstclair/docker-hellomvc-no-mono
RUNTIME = dnx-coreclr-linux-x64.1.0.0-beta6-12120

default: build

build: clean restore publish docker-build
	
clean: 
	rm -rf publish

restore:
	dnu restore .

publish:
	dnu publish . --no-source --runtime $(RUNTIME)

docker-build:
	docker build -t $(NAME) .

push:
	docker push $(NAME)

debug:
	docker run --rm -it $(NAME) /bin/bash

run:
	docker run --rm -it -p=5004:5004 $(NAME)
	
run-d:
	docker run --rm -d -p=5004:5004 $(NAME)
	
release: build push
