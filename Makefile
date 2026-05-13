.PHONY: build test package clean

PYTHON ?= python
POETRY ?= $(PYTHON) -m poetry
PYINSTALLER ?= $(PYTHON) -m PyInstaller

build:
	$(POETRY) install
	# if macOS, build swift
	if [ "$(shell uname)" = "Darwin" ]; then \
		make build-swift; \
	fi

build-swift: aw_watcher_window/aw-watcher-window-macos

aw_watcher_window/aw-watcher-window-macos: aw_watcher_window/macos.swift
	swiftc $^ -o $@

test:
	aw-watcher-window --help

typecheck:
	$(POETRY) run mypy aw_watcher_window/ --ignore-missing-imports

package:
	$(PYINSTALLER) aw-watcher-window.spec --clean --noconfirm

clean:
	rm -rf build dist
	rm -rf aw_watcher_window/__pycache__
	rm aw_watcher_window/aw-watcher-window-macos
