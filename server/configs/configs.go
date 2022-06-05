package configs

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	Database DBConfig
	Stripe   StripeConfig
	Storage  StorageConfig
}

type StripeConfig struct {
	SecretKey string
}
type DBConfig struct {
	PostgresDSN string
}

type StorageConfig struct {
	Endpoint  string
	SecretKey string
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
			Storage: StorageConfig{
				Endpoint:  getEnv("STORAGE_ENDPOINT", "https://storage.supabase.co"),
				SecretKey: getEnv("STORAGE_SECRET_KEY", "31221324sdffwefewsf"),
			},
			Stripe: StripeConfig{
				SecretKey: getEnv("STRIPE_SECRET_KEY", "sk_test_51L6teVLq5jVwlbtcZgpvLz7ZTaMreTBHH5VxQwBIydc1OAlckzVSPdVCOoCBCZJ035sjXEnjVHJqGEW9H1l7Ls6700XqXw5B7r"),
			},
		}
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
