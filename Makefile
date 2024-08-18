# Copyright 2024 dah4k
# SPDX-License-Identifier: MIT-0

SOURCE_PLANTUML   := $(wildcard *.puml)
DIAGRAM_SVG       := $(subst .puml,.svg,$(SOURCE_PLANTUML))
HOST_INSTALL      := $(shell which apt 2>/dev/null || which dnf 2>/dev/null || which zypper 2>/dev/null) install
HOST_UNINSTALL    := $(shell (which apt 2>/dev/null && echo "autoremove") || (which dnf 2>/dev/null && echo "autoremove") || (which zypper 2>/dev/null && echo "rm --clean-deps"))
HOST_REQUIREMENTS := plantuml

_PLANTUML_THEMES := \
	amiga \
	aws-orange \
	black-knight \
	bluegray \
	blueprint \
	carbon-gray \
	cerulean \
	cerulean-outline \
	cloudscape-design \
	crt-amber \
	crt-green \
	cyborg \
	cyborg-outline \
	hacker \
	lightgray \
	mars \
	materia \
	materia-outline \
	metal \
	mimeograph \
	minty \
	mono \
	plain \
	reddress-darkblue \
	reddress-darkgreen \
	reddress-darkorange \
	reddress-darkred \
	reddress-lightblue \
	reddress-lightgreen \
	reddress-lightorange \
	reddress-lightred \
	sandstone \
	silver \
	sketchy \
	sketchy-outline \
	spacelab \
	spacelab-white \
	sunlust \
	superhero \
	superhero-outline \
	toy \
	united \
	vibrant

_ANSI_NORM := \033[0m
_ANSI_CYAN := \033[36m

.PHONY: help usage
help usage:
	@grep -hE '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?##"}; {printf "$(_ANSI_CYAN)%-24s$(_ANSI_NORM) %s\n", $$1, $$2}'

.PHONY: all
all: $(DIAGRAM_SVG) ## Generate diagrams

%.svg: %.puml
	plantuml -tsvg $<

.PHONY: test
test: $(DIAGRAM_SVG) ## View generated diagrams
	qiv $<

gallery: diagram.puml ## Generate PlantUML themes gallery
	[ -d ./gallery ] || mkdir ./gallery
	@for x in $(_PLANTUML_THEMES); do \
		plantuml -tsvg -theme $$x diagram.puml; \
		mv -f diagram.svg ./gallery/diagram-$$x.svg; \
	done
	touch $@

.PHONY: clean
clean: ## Delete generated diagrams
	rm -f $(DIAGRAM_SVG)
	rm -rf ./gallery

.PHONY: install_requirements
install_requirements: ## Install host requirements
	sudo $(HOST_INSTALL) $(HOST_REQUIREMENTS)

.PHONY: uninstall_requirements
uninstall_requirements: ## Uninstall host requirements
	sudo $(HOST_UNINSTALL) $(HOST_REQUIREMENTS)
