# tools.mk - Development tools installation
# Part of go-service-common-make

## BEGIN of Tools installation

.PHONY: download
download: ## Download go.mod dependencies
	@echo "Downloading go.mod dependencies"
	@go mod download

.PHONY: install
install: download ## Install development tools locally
	@echo "Installing tools from $(TOOLS)/tools.go"
	@cd $(TOOLS) && cat tools.go | grep _ | awk -F'"' '{print $$2}' | GOBIN=$(BIN) xargs -tI % go install %
	@touch $(BIN)/.installed

.PHONY: ensure-tools
ensure-tools: ## Ensure tools are installed (runs install only if needed)
	@if [ ! -f $(BIN)/.installed ]; then \
		$(MAKE) install; \
	fi

$(BIN):
	@mkdir -p $(BIN)

## END of Tools installation
