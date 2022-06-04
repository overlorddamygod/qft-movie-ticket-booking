package models

import (
	"time"

	"github.com/google/uuid"
)

type Booking struct {
	Id            int         `gorm:"primary_key" json:"id"`
	TransactionId uuid.UUID   `gorm:"type:uuid;default:uuid_generate_v4()" json:"transaction_id"`
	UserId        uuid.UUID   `gorm:"column:user_id" json:"user_id"`
	SeatId        int         `gorm:"column:seat_id" json:"seat_id"`
	AuditoriumId  int         `gorm:"column:auditorium_id" json:"auditorium_id"`
	ScreeningId   int         `gorm:"column:screening_id" json:"screening_id"`
	Status        int         `gorm:"column:status" json:"status"`
	CreatedAt     time.Time   `gorm:"column:created_at" json:"created_at"`
	Transaction   Transaction `gorm:"foreignKey:TransactionId" json:"transaction"`

	Seat Seat `gorm:"foreignKey:SeatId" json:"seat"`
	// UpdatedAt    time.Time
	// DeletedAt    gorm.DeletedAt `gorm:"index"`
}
