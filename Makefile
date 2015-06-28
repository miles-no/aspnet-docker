NAME = jstclair/docker-hellomvc
RUNTIME = active

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
	docker run --rm -it $(NAME)
	
run-d:
	docker run --rm -d $(NAME)
	
release: build push
