package cmd

import (
	"github.com/trentrosenbaum/cobra-cli-quickstart/quickstart"

	"github.com/spf13/cobra"
)

func buildGreetCommand(app *quickstart.App) *cobra.Command {

	greet := &cobra.Command{
		Use:   "greet",
		Short: "A brief description of your command",
		Long: `A longer description that spans multiple lines and likely contains examples and usage of using your command.`,

		PreRun: func(cmd *cobra.Command, args []string) {
			app.Out = cmd.OutOrStdout()
		},

		Run: func(cmd *cobra.Command, args []string) {
			app.Greet()
		},
	}

	// Add flag processing here

	return greet
}

