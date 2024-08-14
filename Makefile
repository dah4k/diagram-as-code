# Copyright 2024 dah4k
# SPDX-License-Identifier: MIT-0

SOURCE_PLANTUML   := $(wildcard *.plantuml)
DIAGRAM_PDF       := $(subst .plantuml,.pdf,$(SOURCE_PLANTUML))
HOST_INSTALLER    := $(shell type -P apt || type -P dnf || type -P zypper)
HOST_REQUIREMENTS := plantuml

_ANSI_NORM := \033[0m
_ANSI_CYAN := \033[36m

.PHONY: all
all: $(DIAGRAM_PDF) ## Generate PDF diagrams

%.pdf: %.plantuml
	plantuml -tpdf $<

.PHONY: test
test: $(DIAGRAM_PDF) ## Display PDF diagrams
	evince $<

.PHONY: clean
clean: ## Delete PDF diagrams
	rm -f $(DIAGRAM_PDF)

.PHONY: install_requirements
install_requirements: ## Install host requirements
	sudo $(HOST_INSTALLER) install $(HOST_REQUIREMENTS)

.PHONY: help usage
help usage:
	@grep -hE '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?##"}; {printf "$(_ANSI_CYAN)%-20s$(_ANSI_NORM) %s\n", $$1, $$2}'
