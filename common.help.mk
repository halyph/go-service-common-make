# help.mk - Help system with section-based colored output
# Part of go-service-common-make

## BEGIN of General

.PHONY: help
help: ## Show this help
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} { \
		if (/^## BEGIN of/) {section = substr($$0, index($$0, "BEGIN of") + 9); printf "${CYAN}%s${RESET}\n", section} \
		else if  (/^[a-zA-Z0-9._-]+:.*##.*$$/) { \
 		   if (section != "") { \
        	printf "    ${YELLOW}%-20s${GREEN}%s${RESET}\n", $$1, $$2 \
    		} \
		} \
		else if (/^## END/) {section = ""} \
	}' $(MAKEFILE_LIST)

.PHONY: vars
vars: ## Show all Makefile variables
ifndef VARS_OLD
	@echo "$(YELLOW)ERROR:$(RESET) Add 'VARS_OLD := \$$(.VARIABLES)' as first line in your Makefile"
	@exit 1
else
	@$(foreach v, \
		$(sort $(filter-out $(VARS_OLD) VARS_OLD GREEN YELLOW CYAN RESET,$(.VARIABLES))), \
		$(info $(v) = $($(v))))
	@true  # Suppress "nothing to be done" message
endif

.PHONY: list
list: ## List all available targets (useful for completion)
	@$(MAKE) -qp 2>/dev/null | \
		awk -F':' '/^[a-zA-Z0-9][^$$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | \
		grep -v -E '^(Makefile|Dockerfile)' | \
		grep -v '%' | \
		sort -u

## END of General
