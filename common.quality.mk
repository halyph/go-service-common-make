# quality.mk - Quality gates (testing, linting, code generation)
# DO NOT EDIT - Part of go-service-common-make
#
# To contribute changes, please submit a PR to:
# https://github.com/halyph/go-service-common-make

## BEGIN of Quality gates

build-dir:
	@mkdir -p $(BUILD_PATH)

.PHONY: test-generate
test-generate: install generate git-status test ## Install tools, generate mocks, and run tests (for CI)

.PHONY: test
test: run-lint run-test ## Run all quality gates (tests, linting, etc.)

.PHONY: run-lint
run-lint: install ## Run golangci-lint
	$(TOOLS_PATH) golangci-lint --version
	$(TOOLS_PATH) golangci-lint run $(PACKAGES)

.PHONY: fix-lint
fix-lint: install ## Auto-fix linting issues
	$(TOOLS_PATH) golangci-lint run --fix $(PACKAGES)

.PHONY: run-test
run-test: build-dir ## Run tests
	go test $(TEST_FLAGS) $(PACKAGES)

.PHONY: cover
cover: run-test ## Test and open code coverage report
	go tool cover -html=$(COVER_FILE)

.PHONY: generate
generate: install ## Generate code and mocks
	@$(TOOLS_PATH) go generate ./...
	@$(TOOLS_PATH) mockery

.PHONY: git-status
git-status: ## Check if working directory is clean
	@status=$$(git status --porcelain); \
	if [ ! -z "$${status}" ]; \
	then \
		echo "Error - working directory is dirty. Commit those changes!"; \
		echo "$${status}";\
		exit 1; \
	fi

## END of Quality gates

## BEGIN of Cleaning

.PHONY: clean
clean: ## Clean generated files and build artifacts
	rm -rfv $(GENERATED_PACKAGES) $(BUILD_PATH) $(TOOLS_BIN)/.installed

.PHONY: clean-common-make
clean-common-make: ## Remove .common-make directory (forces re-download)
	@echo "🗑️  Removing .common-make/"
	@rm -rf .common-make

.PHONY: show-generated
show-generated: ## List all generated code files
	@echo "📦 Generated code files (GENERATED_DIRS=$(GENERATED_DIRS)):"
	@echo ""
	@for dir in $(GENERATED_DIRS); do \
		echo "🔸 $$dir/:"; \
		files=$$(find . -path "*/$$dir/*.go" -type f 2>/dev/null); \
		if [ -z "$$files" ]; then \
			echo "  (none found)"; \
		else \
			echo "$$files" | sed 's/^\.\//  /'; \
		fi; \
		echo ""; \
	done

## END of Cleaning
