package main

import (
	"github.com/trentrosenbaum/cobra-cli-quickstart/cmd"
	"github.com/trentrosenbaum/cobra-cli-quickstart/config"
	"github.com/trentrosenbaum/cobra-cli-quickstart/quickstart"
	"log"
)


var tag string
var commit string
var branch string

func main() {

	version := config.Version{
		Tag:    tag,
		Commit: commit,
		Branch: branch,
	}

	app, err := quickstart.New()
	if err != nil {
		log.Fatal(err)
	}

	cmd.Execute(app, version)
}
