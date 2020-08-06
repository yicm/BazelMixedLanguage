package cli

import (
	"fmt"
	"github.com/spf13/cobra"
	"os"

	homedir "github.com/mitchellh/go-homedir"
	"github.com/spf13/viper"
)

var cfgFile string

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "hello",
	Short: "Archive of the diff files using git on Linux system.",
	Long:  ``,
	// Uncomment the following line if your bare application
	// has an action associated with it:
	// Run: func(cmd *cobra.Command, args []string) {
	//fmt.Println("project-name: " + viper.GetString("project-name"))
	//},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() error {
	return rootCmd.Execute()
}

func init() {
	cobra.OnInitialize(initConfig)

	// Here you will define your flags and configuration settings.
	// Cobra supports persistent flags, which, if defined here,
	// will be global for your application.

	rootCmd.PersistentFlags().StringVarP(&cfgFile, "config", "c", "", "Config file (default is $HOME/.hello.yaml)")
	rootCmd.PersistentFlags().StringP("project-name", "n", "HELLO", "Your project name")
	rootCmd.PersistentFlags().StringP("app-name", "", "hi_app", "Your app name")
	rootCmd.PersistentFlags().StringP("app-root-path", "", "/usr/local/", "Your app root path")
	viper.BindPFlag("project-name", rootCmd.PersistentFlags().Lookup("project-name"))
	viper.BindPFlag("app-name", rootCmd.PersistentFlags().Lookup("app-name"))
	viper.BindPFlag("app-root-path", rootCmd.PersistentFlags().Lookup("app-root-path"))
	viper.SetDefault("project-name", "HELLO")
	viper.SetDefault("app-name", "hi_app")
	viper.SetDefault("app-root-path", "/usr/local")

	// Cobra also supports local flags, which will only run
	// when this action is called directly.
	//rootCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
	if cfgFile != "" {
		// Use config file from the flag.
		fmt.Println("Use config file from the flag.")
		viper.SetConfigFile(cfgFile)
	} else {
		// Find home directory.
		home, err := homedir.Dir()
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}

		// Search config in home directory with name ".hello" (without extension).
		viper.AddConfigPath(home)
		viper.SetConfigName(".hello")
		viper.SetConfigType("yaml")
		// Optionally look for config in the working directory
		viper.AddConfigPath(".")
	}

	viper.AutomaticEnv() // read in environment variables that match

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err == nil {
		fmt.Println("Using config file:", viper.ConfigFileUsed())
	} else {
		// Everything marked with safe won't overwrite any file,
		// but just create if not existent
		viper.SafeWriteConfig()
	}
}
