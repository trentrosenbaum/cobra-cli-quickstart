package config

import (
	"fmt"
	"github.com/mitchellh/go-homedir"
	"github.com/spf13/viper"
	"log"
)

type Config struct {
	Message string
}

func Load(cfgFileName string) (*Config, error) {

	// Find home directory.
	home, err := homedir.Dir()
	if err != nil {
		log.Fatal(err)
	}

	// Search config in home directory with name ".quickstart" (without extension).
	viper.SetConfigName(cfgFileName)
	viper.AddConfigPath(home)

	viper.AutomaticEnv() // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err != nil {
		fmt.Println("Using config file:", viper.ConfigFileUsed())
	}

	config := &Config{}
	err = viper.Unmarshal(config)
	return config, err
}