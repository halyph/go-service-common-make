# docker.mk - Docker multi-arch build targets
# Part of go-service-common-make

## BEGIN of Building docker images

.PHONY: docker
docker: docker.all ## Build all docker images

.PHONY: docker.all
docker.all: $(DOCKERFILES)

# Pattern rule for building Docker images locally (simple docker build, not buildx)
# Note: build.linux creates build/linux/amd64/ and build/linux/arm64/ subdirectories,
# but Dockerfiles expect flat build/linux/* structure. We flatten amd64 binaries here
# since local testing (Colima, Docker Desktop) only needs amd64 architecture.
# For multi-arch production builds, use 'make docker.push' which handles this correctly.
Docker%: build.linux
	$(eval DOCKERFILE_EXT := $(subst Dockerfile,,$@))
	$(eval DOCKER_REPO_SUFFIX := $(subst .,-,$(DOCKERFILE_EXT)))
	@rm -rf $(BUILD_PATH)/linux-flat
	@mkdir -p $(BUILD_PATH)/linux-flat
	@cp $(BUILD_PATH)/linux/amd64/* $(BUILD_PATH)/linux-flat/ 2>/dev/null || true
	@rm -rf $(BUILD_PATH)/linux
	@mv $(BUILD_PATH)/linux-flat $(BUILD_PATH)/linux
	docker build \
	  -t ${DOCKER_REGISTRY}/${TEAM}/${APPLICATION}${DOCKER_REPO_SUFFIX}:${VERSION} \
	  -f $@ .

## END of Building docker images

## BEGIN of Multi-arch build

.PHONY: buildx-init
buildx-init: ## Initialize docker buildx for multi-arch builds
	docker buildx create --driver-opt network=host --bootstrap --use ${DOCKER_BUILDX_CREATE_OPTS}

.PHONY: docker.build
docker.build: build.linux ## Build docker image for local testing
	docker buildx build \
		--platform $(DOCKER_BUILDX_BUILD_PLATFORM) \
		--tag $(DOCKER_REGISTRY)/$(TEAM)/$(APPLICATION):$(VERSION) \
		--file Dockerfile \
		--load .

.PHONY: docker.push
docker.push: build.linux $(addprefix docker.push.,$(DOCKERFILES)) ## Build and push all docker images

docker.push.%:
	$(eval DOCKERFILE_EXT := $(subst Dockerfile,,$*))
	$(eval DOCKER_REPO_SUFFIX := $(subst .,-,$(DOCKERFILE_EXT)))
	docker buildx build \
	  --platform ${DOCKER_BUILDX_BUILD_PLATFORM} \
	  --network=host \
	  --tag ${DOCKER_REGISTRY}/${TEAM}/${APPLICATION}${DOCKER_REPO_SUFFIX}:${VERSION} \
	  --file $* \
	  --push .

## END of Multi-arch build
