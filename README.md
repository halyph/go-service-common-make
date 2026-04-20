# Common Makefile for Go Projects

Shared Makefile components providing standardized build, test, and deployment workflows for Go repositories.

---

## Requirements

**Git Clone Access:** Users must have git clone access to this repository (`git@github.com:halyph/go-service-common-make.git`). The auto-download mechanism uses `git clone` to fetch go-service-common-make files during the first `make` invocation.

If you don't have access, request it from the project maintainers.

---

## Quick Start

**1. Copy example Makefile:**

```bash
# From go-service-common-make repo
cp ../go-service-common-make/example-repo-Makefile Makefile
```

**2. Edit your Makefile:**

- Set `APPLICATION := your-service-name`
- Set `COMMON_MAKE_VERSION` to [latest tag](https://github.com/halyph/go-service-common-make/tags)
- Verify `COMMON_MAKE_REPO` SSH URL is correct

**3. Add to .gitignore:**
```bash
echo ".common-make/" >> .gitignore
```

**4. Test:**
```bash
make help    # Auto-downloads go-service-common-make
make test
make build.local
```

See [`example-repo-Makefile`](example-repo-Makefile) for complete template with comments.

---

## Available Targets

Run `make help` to see all available targets.

**Common:**
- `make test` - Run lint + tests
- `make generate` - Generate mocks and converters
- `make show-generated` - List all generated code files
- `make clean` - Remove generated code and build artifacts
- `make build.local` - Build for current OS
- `make build.linux` - Build for linux (amd64 + arm64)
- `make docker.push` - Build and push multi-arch images

**Documentation:**
- [common.build.mk](common.build.mk) - Build targets
- [common.docker.mk](common.docker.mk) - Docker targets
- [common.tools.mk](common.tools.mk) - Tools installation
- [common.quality.mk](common.quality.mk) - Quality gates

---

## Configuration

**Required:**
```makefile
APPLICATION := your-service-name
```

**Optional overrides (after include):**
- `TEST_FLAGS += -tags=integration` - Add integration test tag (or use `:=` for complete override)
- `LDFLAGS` - Custom linker flags
- `DOCKER_BUILDX_BUILD_PLATFORM` - Target platforms
- `GENERATED_DIRS += protos stubs` - Add custom generated code directories
- Override any target (e.g., `goldenfiles` for custom paths)

See [`example-repo-Makefile`](example-repo-Makefile) and [common.mk](common.mk) for examples.

---

## Migration from Custom Makefile

1. Copy example: `cp ../go-service-common-make/example-repo-Makefile Makefile`
2. Edit Makefile:
   - Set `APPLICATION := your-repo-name`
   - Set `COMMON_MAKE_VERSION` to [latest tag](https://github.com/halyph/go-service-common-make/tags)
3. Copy custom targets from old Makefile (if any)
4. Update `LD_FLAGS` → `LDFLAGS` (if needed)
5. Add `.common-make/` to `.gitignore`
6. Test: `make test && make build.local`
7. Commit

**Common issues:**
- Tests fail? Check if you need `TEST_FLAGS += -tags=integration` or adjust flags
- goldenfiles fail? Override target with your repo's paths

**Note:** Git history preserves your old Makefile - no backup file needed in repo.

---

## Version Updates

**Update to new version:**
1. Check [available tags](https://github.com/halyph/go-service-common-make/tags)
2. Update `COMMON_MAKE_VERSION := v1.1.0` in your Makefile
3. Run `make clean-common-make && make test`
4. Commit: `git add Makefile && git commit -m "Update go-service-common-make to v1.1.0"`

**Review changelog:** [CHANGELOG.md](CHANGELOG.md)

---

## Release Process (Maintainers)

**Version bump guidelines (SemVer):**

- **MAJOR (v2.0.0)** - Breaking changes requiring consumer updates:
  - Renamed/removed variables (e.g., `TEST_FLAGS` → `GO_TEST_FLAGS`)
  - Removed targets
  - Changed default behavior that breaks existing repos
  - Requires consumer Makefile changes

- **MINOR (v1.1.0)** - New features, backward compatible:
  - New targets (e.g., `make lint-fix`)
  - New optional variables
  - New `.mk` modules
  - No consumer changes required

- **PATCH (v1.0.1)** - Bug fixes, no behavior change:
  - Fix broken targets
  - Documentation updates
  - Performance improvements
  - No consumer impact

**Release steps:**

1. Make changes in feature branch
2. Update `CHANGELOG.md` with version and changes
3. Create PR, review, merge to main
4. Tag: `git tag -a v1.1.0 -m "Release v1.1.0" && git push origin v1.1.0`
5. Create GitHub release with changelog

---

## Local Development & Testing (Maintainers Only)

**For go-service-common-make maintainers testing changes before release.**

### Setup
1. Clone go-service-common-make and a test repo side-by-side:
```bash
~/Projects/
├── go-service-common-make/  # Your working branch
└── my-service/              # Test repo
```

2. Add LOCAL_COMMON_MAKE support to test repo's Makefile:
```makefile
# Add at top, before version marker
ifdef LOCAL_COMMON_MAKE
.common-make/common.mk:
	@echo "📦 Using local common-make from $(LOCAL_COMMON_MAKE)..."
	@rm -rf .common-make
	@mkdir -p .common-make
	@cp $(LOCAL_COMMON_MAKE)/common*.mk .common-make/
	@echo "✓ Local common-make ready"
else
# ... normal version marker rules ...
endif
```

### Test with Real Repo
```bash
cd ~/Projects/my-service
make LOCAL_COMMON_MAKE=../go-service-common-make clean-common-make
make LOCAL_COMMON_MAKE=../go-service-common-make test
make LOCAL_COMMON_MAKE=../go-service-common-make build.local
make LOCAL_COMMON_MAKE=../go-service-common-make docker
```

### Test Multiple Repos
```bash
cd ~/Projects/go-service-common-make
for repo in service1 service2; do
  echo "=== Testing $repo ==="
  (cd ../$repo && make LOCAL_COMMON_MAKE=../go-service-common-make test) || echo "❌ Failed: $repo"
done
```

**Note:** Production repo Makefiles don't have `LOCAL_COMMON_MAKE` - it's only in `example-repo-Makefile`. Add it temporarily for testing, then remove before committing.

---

## Support

- **Issues:** [GitHub Issues](https://github.com/halyph/go-service-common-make/issues)
- **Docs:** Run `make help` or see .mk files
