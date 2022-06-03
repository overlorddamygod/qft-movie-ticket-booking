package configs

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	Database DBConfig
}

type DBConfig struct {
	PostgresDSN string
}

var MainConfig *Config

func NewConfig(envPath string) func() *Config {
	return func() *Config {
		err := godotenv.Load(envPath)

		if err != nil {
			log.Println("Error loading .env file")
		}

		config := &Config{
			Database: DBConfig{
				PostgresDSN: getEnv("POSTGRES_DSN", "POSTGRES_DSN=user=postgres password=31221324sdffwefewsf host=db.sqwe.supabase.co port=5432 dbname=postgres"),
			},
		}
		fmt.Println(config)
		return config
	}
}

func GetConfig() *Config {
	return MainConfig
}

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}

	log.Println("Error loading", key, "... Using default")

	return fallback
}
