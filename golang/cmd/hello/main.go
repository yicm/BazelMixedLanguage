package main

import (
	"fmt"
	"os"

	"github.com/yicm/BazelMixedLanguage/cmd/hello/cli"
)

func main() {
	if err := cli.Execute(); err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
}
