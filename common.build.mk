# build.mk - Multi-architecture Go build targets
# Part of go-service-common-make

## BEGIN of Building binaries

.PHONY: build
build: build.local ## Alias for build.local

.PHONY: build.local
build.local: $(addprefix $(BUILD_PATH)/$(UNAME_S)/$(GOARCH)/,$(BINARIES)) ## Build binaries for local OS and architecture

.PHONY: build.linux
build.linux: $(addprefix $(BUILD_PATH)/linux/amd64/,$(BINARIES)) $(addprefix $(BUILD_PATH)/linux/arm64/,$(BINARIES)) ## Build binaries for linux amd64 and arm64

.PHONY: build.darwin
build.darwin: $(addprefix $(BUILD_PATH)/darwin/amd64/,$(BINARIES)) $(addprefix $(BUILD_PATH)/darwin/arm64/,$(BINARIES)) ## Build binaries for darwin amd64 and arm64

# Build function: $(call fn_build,1:goos,2:goarch,3:binary_name)
define fn_build
GOOS=$(1) GOARCH=$(2) CGO_ENABLED=0 go build $(BUILD_FLAGS) -ldflags="$(LDFLAGS)" -o $(BUILD_PATH)/$(1)/$(2)/$(3) ./cmd/$(3)
@echo "$(3) build for $(1)/$(2) complete"
endef

# Pattern rules for multi-architecture builds
$(BUILD_PATH)/linux/amd64/%: $(SOURCES) $(MIGRATIONS)
	$(call fn_build,linux,amd64,$*)

$(BUILD_PATH)/linux/arm64/%: $(SOURCES) $(MIGRATIONS)
	$(call fn_build,linux,arm64,$*)

$(BUILD_PATH)/darwin/amd64/%: $(SOURCES) $(MIGRATIONS)
	$(call fn_build,darwin,amd64,$*)

$(BUILD_PATH)/darwin/arm64/%: $(SOURCES) $(MIGRATIONS)
	$(call fn_build,darwin,arm64,$*)

## END of Building binaries
