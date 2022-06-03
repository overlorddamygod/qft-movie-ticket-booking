package models

import (
	"time"

	"github.com/google/uuid"
)

type Screening struct {
	Id           int        `gorm:"primary_key" json:"id"`
	AuditoriumId int        `gorm:"column:auditorium_id" json:"auditorium_id"`
	CinemaId     uuid.UUID  `gorm:"column:cinema_id" json:"cinema_id"`
	MovieId      uuid.UUID  `gorm:"column:movie_id" json:"movie_id"`
	CreatedAt    time.Time  `gorm:"column:created_at" json:"created_at"`
	StartTime    time.Time  `gorm:"column:start_time" json:"start_time"`
	Auditorium   Auditorium `gorm:"foreignKey:AuditoriumId" json:"auditorium"`
	// UpdatedAt    time.Time
	// DeletedAt    gorm.DeletedAt `gorm:"index"`
}
