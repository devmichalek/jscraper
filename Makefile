DOCKER_IMAGE_ENV_NAME = docker-jscraper-env
DOCKER_IMAGE_RELEASE_NAME = docker-jscraper-release

DOCKER_CONTAINER_ENV_NAME = $(DOCKER_IMAGE_ENV_NAME)
DOCKER_CONTAINER_RELEASE_NAME = $(DOCKER_IMAGE_RELEASE_NAME)

.PHONY: build-docker-image-env
build-docker-image-env:
	@docker build -f ./Dockerfile.env --tag $(DOCKER_IMAGE_ENV_NAME) .

.PHONY: build-docker-image-release
build-docker-image-release:
	@docker build -f ./Dockerfile.release --tag $(DOCKER_IMAGE_RELEASE_NAME):$(firstword $(MAKECMDGOALS)) .

.PHONY: remove-docker-images-env
remove-docker-images-env:
	@docker rmi '$(DOCKER_IMAGE_ENV_NAME)' 2> /dev/null || true

.PHONY: remove-docker-images-release
remove-docker-images-release:
	@docker rmi '$(DOCKER_IMAGE_RELEASE_NAME)' 2> /dev/null || true

.PHONY: start-docker-container-env
start-docker-container-env:
	@docker run -t -d --name $(DOCKER_CONTAINER_ENV_NAME) $(DOCKER_IMAGE_ENV_NAME)

.PHONY: start-docker-container-release
start-docker-container-release:
	@docker run -d --name $(DOCKER_CONTAINER_RELEASE_NAME) $(DOCKER_IMAGE_RELEASE_NAME)

.PHONY: stop-docker-container
stop-docker-container:
	@docker stop $(firstword $(MAKECMDGOALS))

.PHONY: list-docker-containers
list-docker-containers:
	@docker ps

.PHONY: list-docker-images
list-docker-images:
	@docker images

.PHONY: shell-docker-container-env
shell-docker-container-env:
	@docker exec -it --user juser $(firstword $(MAKECMDGOALS)) /bin/bash
