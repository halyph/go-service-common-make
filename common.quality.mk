# quality.mk - Quality gates (testing, linting, code generation)
# Part of go-service-common-make

## BEGIN of Quality gates

build-dir:
	@mkdir -p $(BUILD_PATH)

.PHONY: test-generate
test-generate: install generate git-status test ## Install tools, generate mocks, and run tests (for CI)

.PHONY: test
test: run-lint run-test ## Run all quality gates (tests, linting, etc.)

.PHONY: run-lint
run-lint: ensure-tools ## Run golangci-lint
	$(BIN_PATH) golangci-lint --version
	$(BIN_PATH) golangci-lint run $(PACKAGES)

.PHONY: fix-lint
fix-lint: ensure-tools ## Auto-fix linting issues
	$(BIN_PATH) golangci-lint run --fix $(PACKAGES)

.PHONY: run-test
run-test: build-dir ## Run tests
	go test $(TEST_FLAGS) $(PACKAGES)

.PHONY: cover
cover: run-test ## Test and open code coverage report
	go tool cover -html=$(COVER_FILE)

.PHONY: generate
generate: ensure-tools ## Generate code and mocks
	@$(BIN_PATH) go generate ./...
	@$(BIN_PATH) mockery

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
	rm -rfv $(GENERATED_PACKAGES) $(BUILD_PATH) $(BIN)/.installed

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
