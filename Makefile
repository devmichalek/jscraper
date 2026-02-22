DOCKER_IMAGE_NAME ?= docker-jscraper
DOCKER_IMAGE_TAG ?= "1.0.0"
DOCKER_CONTAINER_NAME ?= $(DOCKER_IMAGE_NAME)

.PHONY: remove-docker-images
remove-docker-images:
	docker rmi '$(DOCKER_IMAGE_NAME)' 2> /dev/null || true

.PHONY: build-docker-image
build-docker-image: remove-docker-images
	docker build -f ./Dockerfile --tag $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

.PHONY: stop-docker-container
stop-docker-container:
	docker stop $(DOCKER_CONTAINER_NAME) 2> /dev/null || true

.PHONY: stop-docker-container
remove-docker-container: stop-docker-container
	docker rm docker $(DOCKER_CONTAINER_NAME) 2> /dev/null || true

.PHONY: start-docker-container
start-docker-container: remove-docker-container build-docker-image
	docker run -t -d --name $(DOCKER_CONTAINER_NAME) $(DOCKER_IMAGE_NAME)

.PHONY: shell-docker-container
shell-docker-container:
	docker exec -it --user juser $(DOCKER_CONTAINER_NAME) /bin/bash

.PHONY: list-docker-containers
list-docker-containers:
	@docker ps

.PHONY: list-docker-images
list-docker-images:
	@docker images
