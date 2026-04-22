# tools.mk - Development tools installation
# DO NOT EDIT - Part of go-service-common-make
#
# To contribute changes, please submit a PR to:
# https://github.com/halyph/go-service-common-make

## BEGIN of Tools installation

$(TOOLS_BIN)/.installed: $(TOOLS)/tools.go | $(TOOLS_BIN)
	@echo "Installing tools from $(TOOLS)/tools.go"
	@go mod download
	@cd $(TOOLS) && cat tools.go | grep _ | awk -F'"' '{print $$2}' | GOBIN=$(TOOLS_BIN) xargs -tI % go install %
	@touch $(TOOLS_BIN)/.installed

.PHONY: install
install: $(TOOLS_BIN)/.installed ## Install development tools (only if tools.go changed or missing)

$(TOOLS_BIN):
	@mkdir -p $(TOOLS_BIN)

## END of Tools installation
