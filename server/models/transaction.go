package models

import (
	"time"

	"github.com/google/uuid"
)

type Transaction struct {
	Id          uuid.UUID `gorm:"type:uuid;primary_key;default:uuid_generate_v4()" json:"id"`
	UserId      uuid.UUID `gorm:"column:user_id" json:"user_id"`
	ScreeningId int       `gorm:"column:screening_id" json:"screening_id"`
	CreatedAt   time.Time `gorm:"column:created_at" json:"created_at"`
	ExpiresAt   time.Time `gorm:"column:expires_at" json:"expires_at"`
	Bookings    []Booking `gorm:"foreignKey:transaction_id" json:"bookings"`
	// UpdatedAt    time.Time
	// DeletedAt    gorm.DeletedAt `gorm:"index"`
}

func (t *Transaction) IsExpired() bool {
	if t.Id.String() == "00000000-0000-0000-0000-000000000000" {
		return false
	}
	return time.Since(t.CreatedAt) > time.Minute
}
