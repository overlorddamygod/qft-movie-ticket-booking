package models

import (
	"time"

	"github.com/google/uuid"
)

type Auditorium struct {
	Id        int       `gorm:"primary_key" json:"id"`
	Name      string    `gorm:"column:name" json:"name"`
	CinemaId  uuid.UUID `gorm:"column:cinema_id" json:"cinema_id"`
	NoSeats   int       `gorm:"column:no_seats" json:"no_seats"`
	Rows      int       `gorm:"column:rows" json:"rows"`
	Columns   int       `gorm:"column:columns" json:"columns"`
	CreatedAt time.Time `gorm:"column:created_at" json:"created_at"`

	Seats []Seat `gorm:"foreignKey:AuditoriumId" json:"seats"`
	// UpdatedAt    time.Time
	// DeletedAt    gorm.DeletedAt `gorm:"index"`
}

func (Auditorium) TableName() string {
	return "auditoriums"
}
