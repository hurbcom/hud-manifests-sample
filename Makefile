.DEFAULT_GOAL := help
.PHONY: help

DOCKER_STAGE ?= development
INTERACTIVE := $(shell [ -t 0 ] && echo i || echo d)
APPDIR = /usr/hud
PWD=$(shell pwd)
CONTAINER_NAME=hud-catalog
PORT=9090

welcome:
	@printf "\033[33m _               _                             _  __           _        \n"
	@printf "\033[33m| |__  _   _  __| |      _ __ ___   __ _ _ __ (_)/ _| ___  ___| |_ ___  \n"
	@printf "\033[33m| '_ \| | | |/ _\` |_____| '_ \` _ \ / _\` | '_ \| | |_ / _ \/ __| __/ __| \n"
	@printf "\033[33m| | | | |_| | (_| |_____| | | | | | (_| | | | | |  _|  __/\__ \ |_\__ \ \n"
	@printf "\033[33m|_| |_|\__,_|\__,_|     |_| |_| |_|\__,_|_| |_|_|_|  \___||___/\__|___/ \n"
	@printf "\033[33m                                                                        \n"
	@printf "\033[0m\n"


setup: welcome build-docker-image ## Install dependencies to run in Docker
	@echo 'Installing dependecies'


check-if-docker-image-exists:
ifeq ($(shell docker images -q hud/${CONTAINER_NAME}:latest 2> /dev/null | wc -l|bc),0)
	@echo "Docker image not found, building Docker image first"; sleep 2;
	@make build-docker-image
endif

build-docker-image:
	@echo "Building docker image from Dockerfile"
	@docker build --target ${DOCKER_STAGE} . -t hud/${CONTAINER_NAME}:latest

run-dev: welcome check-if-docker-image-exists ## Run container server in development stage
	@echo 'Running on http://localhost:$(PORT)/ping or http://$(CONTAINER_NAME).hud/ping'
	@docker run -t${INTERACTIVE} --rm -v ${PWD}:${APPDIR}:delegated -p $(PORT):80 -e DEBUG=* -e USER_PERM=$(shell id -u):$(shell id -g) -w ${APPDIR} --name ${CONTAINER_NAME} hud/${CONTAINER_NAME}:latest

build-catalog: welcome  ## Compile a new catalog to be downloaded by hudctl
ifneq ($(shell git branch | grep \* | cut -d ' ' -f2-),master)
	@echo ERROR! Make sure you are in \"master\" branch
	@exit 1
endif
	@echo Compiling catalog package
	@cd manifests; tar -zcvf hud-catalog.tgz --exclude hud-catalog.tgz --exclude README.md .; cd ..
	@echo "\nhud-catalog.tgz generated!"


help: welcome
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep ^help -v | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'
