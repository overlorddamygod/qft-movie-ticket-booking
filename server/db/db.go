package db

import (
	"github.com/overlorddamygod/qft-server/configs"
	"github.com/overlorddamygod/qft-server/models"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func NewDB(config *configs.Config) *gorm.DB {
	dialector := postgres.Open(config.Database.PostgresDSN)

	dbCon, err := gorm.Open(dialector, &gorm.Config{})

	if err != nil {
		panic("failed to connect database")
	}

	dbCon.AutoMigrate(&models.Booking{})
	dbCon.AutoMigrate(&models.Auditorium{})
	dbCon.AutoMigrate(&models.Screening{})
	dbCon.AutoMigrate(&models.Seat{})
	dbCon.AutoMigrate(&models.Transaction{})
	dbCon.AutoMigrate(&models.Movie{})
	dbCon.AutoMigrate(&models.Cinema{})

	// dbCon.AutoMigrate(&models.RefreshToken{})
	// dbCon.AutoMigrate(&models.Log{})
	return dbCon
}
