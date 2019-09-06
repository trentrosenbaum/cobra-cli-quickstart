package config

import (
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/suite"
	"os"
	"testing"
)

type ConfigTestSuite struct {
	suite.Suite
	Name string
}

func (suite *ConfigTestSuite) SetupTest() {
	//fmt.Println("Executing Setup.")
}

func (suite *ConfigTestSuite) TearDownTest() {
	//fmt.Println("Executing TearDown.")
}

//  test functions

func (suite *ConfigTestSuite) TestLoadingConfig() {

	// Given
	defer patchEnv("HOME", "test-data/")()

	// When
	result, _ := Load("config")

	// Then
	expectedMessage := "Hello World"
	assert.Equal(suite.T(), expectedMessage, result.Message)
}

func TestGreetingTestSuite(t *testing.T) {
	suite.Run(t, new(ConfigTestSuite))
}

func patchEnv(key, value string) func() {
	bck := os.Getenv(key)
	deferFunc := func() {
		os.Setenv(key, bck)
	}

	if value != "" {
		os.Setenv(key, value)
	} else {
		os.Unsetenv(key)
	}

	return deferFunc
}