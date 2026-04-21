# Changelog

All notable changes to go-service-common-make will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.2.0] - 2026-04-21

### Added
- Simplified Docker support for open-source projects and Docker Hub
- New variables: `DOCKER_USERNAME`, `DOCKER_IMAGE`, `DOCKER_TAG`
- `make docker` - builds all Dockerfiles locally (plain docker, works with Colima)
- `make docker.push` - pushes to Docker Hub
- Image naming: `username/app:tag` (e.g., `oivasiv/go-service-blueprint:latest`)

### Changed
- Docker builds use plain `docker build` instead of buildx (better compatibility)
- Docker targets now build linux/amd64 for local testing (Colima, Docker Desktop)

### Removed
- Company-specific docker variables: `TEAM`, `DOCKER_REGISTRY` (replaced with `DOCKER_USERNAME`, `DOCKER_IMAGE`)
- Buildx targets: `buildx-init`, `docker.build` (overly complex, not needed for local dev)
- Buildx variables: `DOCKER_BUILDX_CREATE_OPTS`, `DOCKER_BUILDX_BUILD_PLATFORM`

## [1.1.1] - 2026-04-20

### Changed
- `make install` now uses marker file pattern (only reinstalls if `tools.go` changed or marker missing)
- Renamed `BIN` → `TOOLS_BIN` for clarity (development tools directory)
- Renamed `BIN_PATH` → `TOOLS_PATH` for clarity

### Removed
- `make download` target (redundant, `go mod download` runs inline during install)
- `make ensure-tools` target (merged into `install` - now both use marker pattern)
- Version comment from `common.mk` header (git tags are the source of truth)

## [1.1.0] - 2026-04-20

### Added
- `ensure-tools` target for optimized tool installation (skips if already installed)
- `.tools/.installed` marker file to track tool installation status
- `run-lint`, `fix-lint`, and `generate` now use `ensure-tools` dependency (faster subsequent runs)
- `make clean` now removes `.tools/.installed` marker

## [1.0.0] - 2026-04-20

### Added
- Initial release of go-service-common-make
- Multi-architecture build support (linux/darwin, amd64/arm64)
- Docker multi-arch build with buildx
- Tools installation from tools/tools.go (.tools/ directory)
- Quality gates: lint, test, generate
- Section-based colored help system
- Git clone distribution with SSH support
- Minimal `TEST_FLAGS` default (repos can append `-tags=integration` with `+=`)
- Standardized on `LDFLAGS` variable naming
- `clean-common-make` target for version updates
- Local development support via `LOCAL_COMMON_MAKE` variable
- `common.*.mk` naming for better file organization
- `GENERATED_DIRS` variable (default: `mocks generated`) to configure generated code directories
- `GENERATED_PACKAGES` variable that finds all directories matching `GENERATED_DIRS`
- `show-generated` target to list all generated code files
- `make clean` now removes all directories in `GENERATED_DIRS`
- Extensibility: repos can add custom dirs with `GENERATED_DIRS += protos stubs`

[Unreleased]: https://github.com/halyph/go-service-common-make/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/halyph/go-service-common-make/compare/v1.1.1...v1.2.0
[1.1.1]: https://github.com/halyph/go-service-common-make/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/halyph/go-service-common-make/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/halyph/go-service-common-make/releases/tag/v1.0.0
