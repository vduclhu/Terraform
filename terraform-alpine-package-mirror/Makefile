
BUILD_ID ?= ${USER}
REGISTRY ?= ""


.PHONY: build_mirror
build_mirror:
	sudo docker build -t ${REGISTRY}alpine-package-mirror:${BUILD_ID} .
	@echo Image tag: ${REGISTRY}alpine-package-mirror:${BUILD_ID}

.PHONY: build_repo
build_repo:
	sudo docker build -t ${REGISTRY}alpine-package-data:${BUILD_ID} repo/
	@echo Image tag: ${REGISTRY}alpine-package-data:${BUILD_ID}

build: build_repo build_mirror
