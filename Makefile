# Copyright 2024 dah4k
# SPDX-License-Identifier: MIT-0

SOURCE_PLANTUML   := $(wildcard *.plantuml)
DIAGRAM_SVG       := $(subst .plantuml,.svg,$(SOURCE_PLANTUML))
HOST_INSTALLER    := $(shell type -P apt || type -P dnf || type -P zypper)
HOST_REQUIREMENTS := plantuml

_ANSI_NORM := \033[0m
_ANSI_CYAN := \033[36m

.PHONY: all
all: $(DIAGRAM_SVG) ## Generate SVG diagrams

%.svg: %.plantuml
	plantuml -tsvg $<

.PHONY: test
test: $(DIAGRAM_SVG) ## Display SVG diagrams
	qiv $<

.PHONY: clean
clean: ## Delete SVG diagrams
	rm -f $(DIAGRAM_SVG)

.PHONY: install_requirements
install_requirements: ## Install host requirements
	sudo $(HOST_INSTALLER) install $(HOST_REQUIREMENTS)

.PHONY: help usage
help usage:
	@grep -hE '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?##"}; {printf "$(_ANSI_CYAN)%-20s$(_ANSI_NORM) %s\n", $$1, $$2}'
