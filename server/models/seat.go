package models

import (
	"time"
)

type Seat struct {
	Id           int       `gorm:"primary_key" json:"id"`
	AuditoriumId int       `gorm:"column:auditorium_id" json:"auditorium_id"`
	Row          int       `gorm:"column:row" json:"row"`
	Number       int       `gorm:"column:number" json:"number"`
	CreatedAt    time.Time `gorm:"column:created_at" json:"created_at"`
	Available    bool      `gorm:"column:available" json:"available"`
	Status       int       `json:"status"`
	// UpdatedAt    time.Time
	// DeletedAt    gorm.DeletedAt `gorm:"index"`
}

func (Seat) TableName() string {
	return "seats"
}
