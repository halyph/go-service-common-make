# Changelog

All notable changes to go-service-common-make will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `GENERATED_PACKAGES` variable to track goverter-generated code
- `show-generated` target to list all generated code (mockery + goverter)
- `make clean` now removes both `mocks/` and `generated/` directories

## [1.0.0] - 2026-04-20

### Added
- Initial release of go-service-common-make
- Multi-architecture build support (linux/darwin, amd64/arm64)
- Docker multi-arch build with buildx
- Tools installation from tools/tools.go
- Quality gates: lint, test, generate
- Section-based colored help system
- Git clone distribution with SSH support
- Minimal `TEST_FLAGS` default (repos can append `-tags=integration` with `+=`)
- Standardized on `LDFLAGS` variable naming
- `clean-common-make` target for version updates
- Local development support via `LOCAL_COMMON_MAKE` variable
- `common.*.mk` naming for better file organization

[Unreleased]: https://github.com/halyph/go-service-common-make/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/halyph/go-service-common-make/releases/tag/v1.0.0
