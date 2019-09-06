package cmd

import (
	"fmt"
	"github.com/trentrosenbaum/cobra-cli-quickstart/config"
	"github.com/trentrosenbaum/cobra-cli-quickstart/quickstart"
	"os"

	"github.com/spf13/cobra"
)

func buildRootCommand(app *quickstart.App, version string) *cobra.Command {

	root := &cobra.Command{}
	root.Version = version

	// Add flag processing here

	return root
}


// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute(app *quickstart.App, version config.Version) {

	root := buildRootCommand(app, version.String())
	root.AddCommand(buildGreetCommand(app))

	if err := root.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
