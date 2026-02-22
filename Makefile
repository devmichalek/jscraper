DOCKER_IMAGE_ENV_NAME ?= docker-jscraper-env
DOCKER_IMAGE_RELEASE_NAME ?= docker-jscraper-release
DOCKER_IMAGE_RELEASE_TAG ?= "1.0.0"
DOCKER_CONTAINER_ENV_NAME ?= $(DOCKER_IMAGE_ENV_NAME)
DOCKER_CONTAINER_RELEASE_NAME ?= $(DOCKER_IMAGE_RELEASE_NAME)

.PHONY: remove-docker-images-env
remove-docker-images-env:
	docker rmi '$(DOCKER_IMAGE_ENV_NAME)' 2> /dev/null || true

.PHONY: build-docker-image-env
build-docker-image-env: remove-docker-images-env
	docker build -f ./Dockerfile.env --tag $(DOCKER_IMAGE_ENV_NAME) .

.PHONY: stop-docker-container-env
stop-docker-container-env:
	docker stop $(DOCKER_CONTAINER_ENV_NAME) 2> /dev/null || true

.PHONY: stop-docker-container-env
remove-docker-container-env: stop-docker-container-env
	docker rm docker $(DOCKER_CONTAINER_ENV_NAME) 2> /dev/null || true

.PHONY: start-docker-container-env
start-docker-container-env: remove-docker-container-env build-docker-image-env
	docker run -t -d --name $(DOCKER_CONTAINER_ENV_NAME) $(DOCKER_IMAGE_ENV_NAME)

.PHONY: shell-docker-container-env
shell-docker-container-env:
	docker exec -it --user juser $(DOCKER_CONTAINER_ENV_NAME) /bin/bash

.PHONY: list-docker-containers
list-docker-containers:
	@docker ps

.PHONY: list-docker-images
list-docker-images:
	@docker images

.PHONY: build
build:
	docker build -f ./Dockerfile.release --tag $(DOCKER_IMAGE_RELEASE_NAME):$(DOCKER_IMAGE_RELEASE_TAG) .

.PHONY: start
start:
	docker run -d --name $(DOCKER_CONTAINER_RELEASE_NAME) $(DOCKER_IMAGE_RELEASE_NAME)
