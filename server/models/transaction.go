package models

import (
	"time"

	"github.com/google/uuid"
)

type Transaction struct {
	Id              uuid.UUID `gorm:"type:uuid;primary_key;default:uuid_generate_v4()" json:"id"`
	UserId          uuid.UUID `gorm:"column:user_id" json:"user_id"`
	ScreeningId     int       `gorm:"column:screening_id" json:"screening_id"`
	CreatedAt       time.Time `gorm:"column:created_at" json:"created_at"`
	ExpiresAt       time.Time `gorm:"column:expires_at" json:"expires_at"`
	PaymentIntentID string    `gorm:"column:payment_intent_id" json:"payment_intent_id"`
	Paid            bool      `gorm:"column:paid" json:"paid"`

	Bookings []Booking `gorm:"foreignKey:TransactionId" json:"bookings"`
	// UpdatedAt    time.Time
	// DeletedAt    gorm.DeletedAt `gorm:"index"`
}

func (Transaction) TableName() string {
	return "transactions"
}

func (t *Transaction) IsExpired() bool {
	return t.ExpiresAt.Before(time.Now())
}
