# golang-quickstart
This is a simple quickstart project written in Go.  The aim of the repo is to provide a starting point for a new Go project.

The project provides main.go and a main_test.go files that tests the printing of a greeting to the terminal.

## Makefile

A Makefile is provided to test, build and package the project.  Additionally the Makefile will allow the project to 
be distributed as three separate binaries cover, Linux, MacOS and Windows.

The dependency management is fulfill through the dep tool, (located at https://github.com/golang/dep).  It is understood 
the future direction of dependency management within Go is through Go Modules, but right now this is not the focus of the project.

The following Makefile targets are of interest
* make clean
  * Resets the project directory by deleting binaries and distribution files.
* make dependencies
  * Downloads and installs the dep tool if not found.
  * Ensures that all the required project dependencies are installed.
* make test
  * Executes the project tests
* make build
  * Compiles and constructs a binary into the bin directory.
* make dist
  * Compiles and constructs binaries for several operating systems.  Each binary is packaged into an achive under the dist directory.
* make install
  * Installs the binary into the GOPATH.
* make run
  * excutes the binary installed in the GOPATH
  



