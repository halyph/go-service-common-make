# Common Makefile for Go Projects
#
# This file is automatically downloaded from go-service-common-make repository.
# This file contains common targets and patterns for Go projects.
# Include this in your repo-specific Makefile with:
#   include .common-make/common.mk

# Ensure required variables are set by the consumer
ifndef APPLICATION
$(error APPLICATION variable must be set in your Makefile before including common.mk)
endif

# Common variables with sensible defaults (can be overridden)
VERSION ?= latest

# Auto-detect binaries, sources, packages
BINARIES           := $(shell ls ./cmd 2>/dev/null)
SOURCES            := $(shell find . -name '*.go' 2>/dev/null)
MIGRATIONS         := $(shell find ./res/migrations -name '*.sql' 2>/dev/null | grep -v -E " ")
PACKAGES           := $(shell go list -f '{{.Dir}}' ./... 2>/dev/null | grep -v -E '/(mocks|tools)$$')

# Generated code directories (can be extended: GENERATED_DIRS += protos stubs)
GENERATED_DIRS     ?= mocks generated
GENERATED_PACKAGES := $(shell for dir in $(GENERATED_DIRS); do find . -name "$$dir" -type d 2>/dev/null; done)

DOCKERFILES        := $(wildcard Dockerfile*)

# Build configuration
BUILD_PATH     := build
COVER_FILE     := $(BUILD_PATH)/coverprofile.txt

GIT_HEAD       := $(shell git rev-parse --short HEAD)
LDFLAGS        := -X main.Version=$(VERSION) -X main.GitHead=$(GIT_HEAD) -s -w
TEST_FLAGS     ?= -race -count=1 -mod=readonly -cover -coverprofile $(COVER_FILE)
BUILD_FLAGS    := -mod=readonly -v

# Detect OS and architecture
UNAME_S := $(shell uname -s | tr '[:upper:]' '[:lower:]')
UNAME_M := $(shell uname -m)
GOARCH  := $(if $(filter x86_64,$(UNAME_M)),amd64,$(if $(filter arm64,$(UNAME_M)),arm64,$(UNAME_M)))

# Colors for output
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
CYAN   := $(shell tput -Txterm setaf 6)
RESET  := $(shell tput -Txterm sgr0)

# Tools configuration
TOOLS_BIN  := $(shell pwd)/.tools
TOOLS      := $(shell pwd)/tools
TOOLS_PATH := PATH="$(abspath $(TOOLS_BIN)):$$PATH"

# Set default goal to help (must be set before any targets are defined)
.DEFAULT_GOAL := help

.PHONY: default
default: help

# Include modular makefiles
COMMON_MAKE_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(COMMON_MAKE_DIR)common.build.mk
include $(COMMON_MAKE_DIR)common.docker.mk
include $(COMMON_MAKE_DIR)common.tools.mk
include $(COMMON_MAKE_DIR)common.quality.mk
include $(COMMON_MAKE_DIR)common.help.mk

.SUFFIXES:  # Clear built-in suffix rules
