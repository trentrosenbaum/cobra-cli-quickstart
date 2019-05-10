SHELL := /bin/bash

# The name of the binary (default is current directory name)
TARGET := $(shell echo $${PWD\#\#*/})
.DEFAULT_GOAL := $(TARGET)

HAS_DEP := $(shell command -v dep;)
DEP_VERSION := 0.5.2

# Output directories for binaries and distributions.
BIN := $(CURDIR)/bin
DIST := $(CURDIR)/dist
OUPUT_FILES := $(BIN) $(DIST)

# Metadata about project provided through linker flags
VERSION := "v0.1.0-SNAPSHOT"
BUILD := `git rev-parse HEAD`
LDFLAGS := -ldflags "-X=main.Version=$(VERSION) -X=main.Build=$(BUILD)"

# Go source files, excluding vendor directory
SRC := $(shell find . -type f -name '*.go' -not -path "./vendor/*")

.PHONY: all build clean test install uninstall fmt simplify check run dist benchmark deps

all: deps check test install

$(TARGET): $(SRC)
	@ mkdir -p $(BIN)
	@ go build $(LDFLAGS) -o $(BIN)/$(TARGET) main.go

build: $(TARGET)
	@ true

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

	@ test -z $(shell gofmt -l main.go | tee /dev/stderr) || echo "[WARN] Fix formatting issues with 'make fmt'"
	@ for d in $$(go list ./... | grep -v /vendor/); do golint $${d}; done
	@ go vet ./...

run: install
	@ $(TARGET) ${ARGS}

dist:
	@ mkdir -p $(BIN)
	@ mkdir -p $(DIST)

	@ echo "==> Building Linux distribution"
	@ CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build $(LDFLAGS) -o $(BIN)/$(TARGET)
	tar -zcvf $(DIST)/$(TARGET)-linux-$(VERSION).tgz README.md LICENSE.txt -C $(BIN) $(TARGET)

	@ echo "==> Building MaxOS distribution"
	@ CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build $(LDFLAGS) -o $(BIN)/$(TARGET)
	tar -zcvf $(DIST)/$(TARGET)-macos-$(VERSION).tgz README.md LICENSE.txt -C $(BIN) $(TARGET)

	@ echo "==> Building Windows distribution"
	@ CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build $(LDFLAGS) -o $(BIN)/$(TARGET).exe
	tar -zcvf $(DIST)/$(TARGET)-windows-$(VERSION).tgz README.md LICENSE.txt -C $(BIN) $(TARGET).exe

benchmark:
	@ echo "==> Benchmarking $(TARGET)"
	@ go test -bench -v ./...

deps:
ifndef HAS_DEP
	@ echo "==> Installing dep"

	wget -q -O $(GOPATH)/bin/dep https://github.com/golang/dep/releases/download/$(DEP_VERSION)/dep-darwin-amd64
	chmod +x $(GOPATH)/bin/dep
endif
	@ echo "==> Downloading dependencies for $(TARGET)"

	@ dep ensure