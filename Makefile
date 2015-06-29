NAME = jstclair/docker-hellomvc
RUNTIME = active
PORT = 5004

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
	docker run --rm -it -p $(PORT):$(PORT) $(NAME) /bin/bash

run:
	docker run --rm -it -p $(PORT):$(PORT) $(NAME)
	
run-d:
	docker run --rm -d -p $(PORT):$(PORT) $(NAME)
	
release: build push
