# docker.mk - Docker build and push targets
# Part of go-service-common-make

## BEGIN of Docker configuration

# Docker image naming (override in your Makefile if needed)
DOCKER_USERNAME  ?= $(USER)
DOCKER_IMAGE     ?= $(DOCKER_USERNAME)/$(APPLICATION)
DOCKER_TAG       ?= $(VERSION)

## END of Docker configuration

## BEGIN of Building docker images

.PHONY: docker
docker: $(DOCKERFILES) ## Build all docker images locally

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

## END of Building docker images

## BEGIN of Pushing images

.PHONY: docker.push
docker.push: $(addprefix push.,$(DOCKERFILES)) ## Build and push all docker images

push.%: build.linux
	$(eval DOCKERFILE_EXT := $(subst Dockerfile,,$*))
	$(eval IMAGE_SUFFIX := $(subst .,-,$(DOCKERFILE_EXT)))
	@echo "🐳 Building and pushing $(DOCKER_IMAGE)$(IMAGE_SUFFIX):$(DOCKER_TAG)..."
	docker build \
	  -t $(DOCKER_IMAGE)$(IMAGE_SUFFIX):$(DOCKER_TAG) \
	  --build-arg TARGETARCH=amd64 \
	  -f $* .
	docker push $(DOCKER_IMAGE)$(IMAGE_SUFFIX):$(DOCKER_TAG)

## END of Pushing images
