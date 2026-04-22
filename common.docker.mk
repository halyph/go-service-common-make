# docker.mk - Docker build and push targets
# DO NOT EDIT - Part of go-service-common-make
#
# To contribute changes, please submit a PR to:
# https://github.com/halyph/go-service-common-make

## BEGIN of Docker

# Docker image naming (override in your Makefile if needed)
DOCKER_USERNAME  ?= $(USER)
DOCKER_IMAGE     ?= $(DOCKER_USERNAME)/$(APPLICATION)
DOCKER_TAG       ?= $(VERSION)

.PHONY: docker
docker: $(DOCKERFILES) ## Build all docker images locally

.PHONY: docker.push
docker.push: $(addprefix push.,$(DOCKERFILES)) ## Build and push all docker images

# Pattern rule: builds each Dockerfile found
# Creates linux/amd64 images for local testing (Colima, Docker Desktop)
# Example: Dockerfile → user/app:latest, Dockerfile.extra → user/app-extra:latest
Docker%: build.linux
	$(eval DOCKERFILE_EXT := $(subst Dockerfile,,$@))
	$(eval IMAGE_SUFFIX := $(subst .,-,$(DOCKERFILE_EXT)))
	@echo "🐳 Building $(DOCKER_IMAGE)$(IMAGE_SUFFIX):$(DOCKER_TAG) (linux/amd64)..."
	docker build \
	  -t $(DOCKER_IMAGE)$(IMAGE_SUFFIX):$(DOCKER_TAG) \
	  --build-arg TARGETARCH=amd64 \
	  -f $@ .

push.%: build.linux
	$(eval DOCKERFILE_EXT := $(subst Dockerfile,,$*))
	$(eval IMAGE_SUFFIX := $(subst .,-,$(DOCKERFILE_EXT)))
	@echo "🐳 Building and pushing $(DOCKER_IMAGE)$(IMAGE_SUFFIX):$(DOCKER_TAG)..."
	docker build \
	  -t $(DOCKER_IMAGE)$(IMAGE_SUFFIX):$(DOCKER_TAG) \
	  --build-arg TARGETARCH=amd64 \
	  -f $* .
	docker push $(DOCKER_IMAGE)$(IMAGE_SUFFIX):$(DOCKER_TAG)

## END of Docker
