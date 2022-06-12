package models

import (
	"time"

	"github.com/google/uuid"
)

type Cinema struct {
	Id uuid.UUID `gorm:"primary_key" json:"id"`

	Name    string `gorm:"column:name" json:"name"`
	Address string `gorm:"column:address" json:"address"`

	CreatedAt time.Time `gorm:"column:created_at" json:"created_at"`

	// auditoriums
	Auditoriums []Auditorium `gorm:"foreignKey:CinemaId" json:"auditoriums"`
}

func (Cinema) TableName() string {
	return "cinemas"
}
