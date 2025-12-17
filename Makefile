MKDOCS_IMAGE = squidfunk/mkdocs-material:9.1.14
NODE_IMAGE = node:22-alpine
DOCKER = docker run --rm -v $(PWD):/docs -w /docs

.PHONY: serve
serve: build/runner
	@$(DOCKER) -it -p 8000:8000 $(MKDOCS_IMAGE)

.PHONY: build
build: build/runner
	@$(DOCKER) $(MKDOCS_IMAGE) build --clean --site-dir site --verbose

.PHONY: build/runner
build/runner:
	@$(DOCKER) -e SANTA_LANG_NPM_TOKEN -w /docs/runner $(NODE_IMAGE) sh -c "yarn && yarn build"
