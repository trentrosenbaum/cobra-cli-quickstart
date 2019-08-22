SHELL := /bin/bash

# The name of the binary (default is current directory name)
TARGET ?= $(shell echo $${PWD\#\#*/})
.DEFAULT_GOAL := $(TARGET)

HAS_GOLINT := $(shell command -v golint;)

VENDOR := $(CURDIR)/vendor

# Tags specific for building
GOTAGS ?=

# Output directories for binaries and distributions.
BIN := $(CURDIR)/bin
DIST := $(CURDIR)/dist
OUPUT_FILES := $(BIN) $(DIST)

PLATFORMS ?= darwin linux windows
ARCH ?= amd64
OS = $(word 1, $@)

# Metadata about project provided through linker flags
VERSION ?= vlocal
COMMIT = $(shell git rev-parse HEAD)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)

LDFLAGS := -ldflags "-X=main.tag=$(VERSION) -X=main.commit=$(COMMIT) -X=main.branch=$(BRANCH)"
BUILDARGS ?=

# Go source files, excluding vendor directory
SRC := $(shell find . -type f -name '*.go' -not -path "./vendor/*")

all: dependencies check test build
.PHONY: all

$(TARGET): $(SRC)
	@ mkdir -p $(BIN)
	go build $(BUILDARGS) $(LDFLAGS) -o $(BIN)/$(TARGET) .

build: $(TARGET)
	@ echo "==> Building $(TARGET)"
.PHONY: build

clean:
	@ echo "==> Cleaning output files."
ifneq ($(OUPUT_FILES),)
	rm -rf $(OUPUT_FILES)
endif
.PHONY: clean

bootstrap:
ifndef HAS_GOLINT
	go get -u golang.org/x/lint/golint
	chmod +x $(GOPATH)/bin/golint
endif
.PHONY: bootstrap

test:
	@ echo "==> Testing $(TARGET)"
	@ go test $(BUILDARGS) -v -timeout=30s -tags="${GOTAGS}" ./...
.PHONY: test

test-race:
	@ echo "==> Testing $(TARGET)"
	@ go test $(BUILDARGS) -v -race -timeout=60s -tags="${GOTAGS}" ./...
.PHONY: test-race

install:
	@ echo "==> Installing $(TARGET)"
	@ go install $(BUILDARGS) $(LDFLAGS)
.PHONY: install

uninstall: clean
	@ echo "==> Uninstalling $(TARGET)"
	rm -f $$(which ${TARGET})
.PHONY: uninstall

fmt:
	@ gofmt -l -w $(SRC)
.PHONY: fmt

simplify:
	@ gofmt -s -l -w $(SRC)
.PHONY: simplify

check:
	@ echo "==> Checking $(TARGET)"
	@ gofmt -l -s $(SRC) | read; if [ $$? == 0 ]; then echo "[WARN] Fix formatting issues with 'make fmt'"; exit 1; fi
	@ for d in $$(go list ./... | grep -v /vendor/); do golint $${d}; done
	@ go vet ./...
.PHONY: check

run: install
	@ $(TARGET) ${ARGS}
.PHONY: run

$(PLATFORMS):
	@ echo "==> Building $(OS) distribution"
	@ mkdir -p $(BIN)/$(OS)/$(ARCH)
	@ mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=$(OS) GOARCH=$(ARCH) go build $(BUILDARGS) $(LDFLAGS) -o $(BIN)/$(OS)/$(ARCH)/$(TARGET)
	tar -zcvf $(DIST)/$(TARGET)-$(VERSION)-$(OS)-$(ARCH).tgz README.md LICENSE.md -C $(BIN)/$(OS)/$(ARCH) $(TARGET)
.PHONY: $(PLATFORMS)

dist: $(PLATFORMS)
	@ true
.PHONY: dist

benchmark:
	@ echo "==> Benchmarking $(TARGET)"
	@ go test $(BUILDARGS) -bench -v ./...
.PHONY: benchmark

dependencies:
	@ echo "==> Downloading dependencies for $(TARGET)"
	@ go mod download
.PHONY: dependencies

vendor-dependencies:
	@ echo "==> Downloading dependencies for $(TARGET)"
	@ go mod vendor
.PHONY: vendor-dependencies

tidy-dependencies:
	@ echo "==> Tidying dependencies for $(TARGET)"
	@ go mod tidy
.PHONY: tidy-dependencies

clean-dependencies:
	@ echo "==> Cleaning dependencies for $(TARGET)"
	@ rm -rf $(VENDOR)
.PHONY: clean-dependencies