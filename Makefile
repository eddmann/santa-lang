MKDOCS_IMAGE = squidfunk/mkdocs-material:9.1.14
BUN_IMAGE = oven/bun:1-alpine
DOCKER = docker run --rm -v $(PWD):/docs -w /docs

.PHONY: serve
serve: build/runner
	@$(DOCKER) -it -p 8000:8000 $(MKDOCS_IMAGE)

.PHONY: build
build: build/runner
	@$(DOCKER) $(MKDOCS_IMAGE) build --clean --site-dir site --verbose

.PHONY: build/runner
build/runner:
	@$(DOCKER) -e SANTA_LANG_NPM_TOKEN -w /docs/runner $(BUN_IMAGE) sh -c "bun install && bun run build"
