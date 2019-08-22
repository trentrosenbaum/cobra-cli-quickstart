package main

import "github.com/trentrosenbaum/cobra-cli-quickstart/cmd"


var tag string
var commit string
var branch string

func main() {

	version := cmd.Version{
		Tag:    tag,
		Commit: commit,
		Branch: branch,
	}

	cmd.Execute(version)
}
