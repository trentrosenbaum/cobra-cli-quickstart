SHELL := /bin/bash

# The name of the binary (default is current directory name)
TARGET := $(shell echo $${PWD\#\#*/})
.DEFAULT_GOAL := $(TARGET)

DEP_VERSION := 0.5.2
DEP_TOOL := $(GOBIN)/dep
VENDOR := $(CURDIR)/vendor

# Output directories for binaries and distributions.
BIN := $(CURDIR)/bin
DIST := $(CURDIR)/dist
OUPUT_FILES := $(BIN) $(DIST)

PLATFORMS ?= darwin linux windows
ARCH ?= amd64
OS = $(word 1, $@)


# Metadata about project provided through linker flags
VERSION ?= "vlocal"
COMMIT=$(shell git rev-parse HEAD)
BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

LDFLAGS := -ldflags "-X=main.version=$(VERSION) -X=main.commit=$(COMMIT) -X=main.branch=$(BRANCH)"

# Go source files, excluding vendor directory
SRC := $(shell find . -type f -name '*.go' -not -path "./vendor/*")

.PHONY: all build clean test install uninstall fmt simplify check run dist benchmark dependencies $(PLATFORMS)

all: dependencies check test build

$(TARGET): $(SRC)
	@ mkdir -p $(BIN)
	@ go build $(LDFLAGS) -o $(BIN)/$(TARGET) .

build: $(TARGET)
	@ echo "==> Building $(TARGET)"

clean:
	@ echo "==> Cleaning output files."
ifneq ($(OUPUT_FILES),)
	rm -rf $(OUPUT_FILES)
endif

test:
	@ echo "==> Testing $(TARGET)"
	@ go test -v ./...

install:
	@ echo "==> Installing $(TARGET)"
	@ go install $(LDFLAGS)

uninstall: clean
	@ echo "==> Uninstalling $(TARGET)"
	rm -f $$(which ${TARGET})

fmt:
	@ gofmt -l -w $(SRC)

simplify:
	@ gofmt -s -l -w $(SRC)

check:
	@ echo "==> Checking $(TARGET)"
	@ gofmt -l -s $(SRC) | read; if [ $$? == 0 ]; then echo "[WARN] Fix formatting issues with 'make fmt'"; exit 1; fi
	@ for d in $$(go list ./... | grep -v /vendor/); do golint $${d}; done
	@ go vet ./...

run: install
	@ $(TARGET) ${ARGS}

$(PLATFORMS):
	@ echo "==> Building $(OS) distribution"
	@ mkdir -p $(BIN)/$(OS)/$(ARCH)
	@ mkdir -p $(DIST)
	CGO_ENABLED=0 GOOS=$(OS) GOARCH=$(ARCH) go build $(LDFLAGS) -o $(BIN)/$(OS)/$(ARCH)/$(TARGET)
	tar -zcvf $(DIST)/$(TARGET)-$(VERSION)-$(OS).tgz README.md LICENSE.txt -C $(BIN)/$(OS)/$(ARCH) $(TARGET)

dist: $(PLATFORMS)
	@ true

benchmark:
	@ echo "==> Benchmarking $(TARGET)"
	@ go test -bench -v ./...

$(DEP_TOOL):
	@ echo "==> Installing dep tool"
	wget -q -O $(DEP_TOOL) https://github.com/golang/dep/releases/download/$(DEP_VERSION)/dep-darwin-amd64
	chmod +x $(DEP_TOOL)

dependencies: $(DEP_TOOL)
	@ echo "==> Downloading dependencies for $(TARGET)"
	@ dep ensure

clean-dependencies:
	@ echo "==> Cleaning dependencies for $(TARGET)"
	rm -rf $(VENDOR)