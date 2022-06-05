package models

import (
	"time"

	"github.com/google/uuid"
)

type Movie struct {
	Id          uuid.UUID `gorm:"primary_key" json:"id"`
	Name        string    `gorm:"column:name" json:"name"`
	Description string    `gorm:"column:description" json:"description"`
	Banner      string    `gorm:"column:banner" json:"banner"`
	Trailer     string    `gorm:"column:trailer" json:"trailer"`
	Length      int       `gorm:"column:length" json:"length"`

	ReleaseDate time.Time `gorm:"column:release_date" json:"release_date"`
	CreatedAt   time.Time `gorm:"column:created_at" json:"created_at"`
}

func (Movie) TableName() string {
	return "movies"
}
