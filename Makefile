IMAGE = squidfunk/mkdocs-material:9.1.14
DOCKER = docker run --rm -v $(PWD):/docs -w /docs

.PHONY: serve
serve:
	@$(DOCKER) -it -p 8000:8000 $(IMAGE)

.PHONY: build
build:
	@$(DOCKER) $(IMAGE) build --clean --site-dir site --verbose
