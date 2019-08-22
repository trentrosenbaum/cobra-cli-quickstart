# cobra-cli-quickstart
[![Build Status](https://travis-ci.org/trentrosenbaum/cobra-cli-quickstart.svg?branch=introduce-travis-ci)](https://travis-ci.org/trentrosenbaum/cobra-cli-quickstart)

This is a simple cobra cli quickstart project written in Go.  The aim of the repo is to provide a starting point for a new Go cli project.

The project provides main.go and a cmd/root.go files that form a starting point for a cli.  The cobra cli can the be used to create additional commands.

## Makefile
A Makefile is provided to test, build and verify the project.  Additionally the Makefile will allow the project to 
be distributed as three separate binaries covering, Linux, MacOS and Windows.

### Managing Dependencies
The dependency management is fulfilled through go modules.  The `GO111MODULE` environment variable should be set to `on`

```bash
export GO111MODULE=on
```

To download the dependencies execute the `dependencies` target.  This will download the dependencies into the Go cache.

```bash
make dependencies
```

To vendor the dependencies into the location project execute the `vendor-dependencies` target.  This will download the dependencies into a `vendor` directory within the project.

```bash
make vendor-dependencies
```

To remove the vendor directory execute the `clean-dependencies` target.  This will delete the `vendor` directory.

```bash
make clean-dependencies
```

### Building the Project
To build the project execute the `build` target.  The binary will be placed in a `bin` directory.

```bash
make build
```
To execute the binary the following command can be executed at the root of the project.

```bash
./bin/cobra-cli-quickstart
```

### Testing the Project
To test the project execute the `test` target.

```bash
make test
```

### Creating a Distribution
To build a distribution of the project execute the dist target.  The default behaviour is to build linux, darwin and windows distributions.
Distributions are made up of a compressed tar file under the `dist` directory.

```bash
make dist
```

To override the default list of distributions a variable called `PLATFORMS` can be defined.  The following example builds darwin and windows distributions

```bash
PLATFORMS="darwin windows" make dist
``` 

Individual distributions can be created by using the distribution name.  For example `darwin`, `linux` or `windows` can be built using the following commands.

```bash
make darwin
make linux
make windows
```

All of the binaries built into a directory structure under the `bin` directory.  The structure reflects the operating system and architecture.
For example darwin amd64 binaries are built into the following structure

```
cobra-cli-quickstart
|-- bin
    |-- darwin
        |-- amd64
            |-- cobra-cli-quickstart

```

### Cleaning the Project

To clean the project execute the clean target.  If the bin or dist directories were previously created then they will be deleted.
The cleaning of the vendor directory is handled by the `clean-dependencies`

```bash
make clean
```

### Additional targets

The following is a brief list of additional targets that can be executed against the project.

* `make bootstrap`
  * Ensures that add tools are present in the build environment. For example `golint`.
* `make install` / `make uninstall`
  * Installs or uninstalls the built binary into the `$GOPATH/bin` directory.
* `make fmt`
  * Executes `go fmt` over the project.
* `make benchmark`
  * Executes any benchmark tests against the project.
* `make check`
  * Executes `go fmt` and `golint` against the project.
  
## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to the project.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors

* **Trent Rosenbaum** - *Initial work* - [trentrosenbaum](https://github.com/trentrosenbaum)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the ? License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* List any people or projects that have inspiration this project