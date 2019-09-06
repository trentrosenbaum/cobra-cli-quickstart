package quickstart

import (
	"fmt"
	"github.com/trentrosenbaum/cobra-cli-quickstart/config"
	"io"
	"os"
)

type App struct {
	Out    io.Writer
	Err    io.Writer
	Config *config.Config
}

func New() (*App, error) {

	cfg, err := config.Load(".quickstart")
	if err != nil {
		return nil, err
	}

	app := &App{
		Out:    os.Stdout,
		Err:	os.Stderr,
		Config: cfg,
	}
	return app, nil
}

func (a *App) Greet() {
	fmt.Fprintf(a.Out, a.Config.Message)
}
