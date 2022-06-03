package models

import (
	"time"

	"github.com/google/uuid"
)

type Cinema struct {
	Id            int       `gorm:"primary_key"`
	Auditorium_id int       `gorm:"column:auditorium_id"`
	CinemaId      uuid.UUID `gorm:"column:cinema_id"`
	MovieId       uuid.UUID `gorm:"column:movie_id"`
	CreatedAt     time.Time
	StartTime     time.Time `gorm:"column:start_time"`
	// UpdatedAt    time.Time
	// DeletedAt    gorm.DeletedAt `gorm:"index"`
}
