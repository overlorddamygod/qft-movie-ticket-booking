package models

import (
	"bytes"
	"fmt"
	"time"

	"github.com/google/uuid"
	"github.com/johnfercher/maroto/pkg/color"
	"github.com/johnfercher/maroto/pkg/consts"
	"github.com/johnfercher/maroto/pkg/pdf"
	"github.com/johnfercher/maroto/pkg/props"
)

type Transaction struct {
	Id              uuid.UUID `gorm:"type:uuid;primary_key;default:uuid_generate_v4()" json:"id"`
	UserId          uuid.UUID `gorm:"column:user_id" json:"user_id"`
	ScreeningId     int       `gorm:"column:screening_id" json:"screening_id"`
	CreatedAt       time.Time `gorm:"column:created_at" json:"created_at"`
	ExpiresAt       time.Time `gorm:"column:expires_at" json:"expires_at"`
	PaymentIntentID string    `gorm:"column:payment_intent_id" json:"payment_intent_id"`
	Paid            bool      `gorm:"column:paid" json:"paid"`
	TotalPrice      int       `gorm:"column:total_price" json:"total_price"`

	Bookings  []Booking `gorm:"foreignKey:TransactionId" json:"bookings"`
	Screening Screening `gorm:"foreignKey:ScreeningId" json:"screening"`
	// UpdatedAt    time.Time
	// DeletedAt    gorm.DeletedAt `gorm:"index"`
}

func (Transaction) TableName() string {
	return "transactions"
}

func (t *Transaction) IsExpired() bool {
	return t.ExpiresAt.Before(time.Now())
}

func (t *Transaction) BuildReceipt() (bytes.Buffer, string, error) {
	m := pdf.NewMarotoCustomSize(consts.Portrait, "QFT", "mm", 144, 150)

	m.SetPageMargins(10, 0, 10)
	t.buildHeading(m)
	m.RegisterFooter(func() {
		AddLine(m, "Enjoy your movie experience at QFT Cinemas", 15, consts.Center)
	})
	for _, booking := range t.Bookings {

		seatName := booking.Seat.Info(t.Screening.Auditorium.Rows)
		seatInfo := fmt.Sprintf("Seat Info: %s", seatName)

		m.Row(40, func() {
			m.Col(9, func() {
				m.Text(t.Screening.Auditorium.Name, props.Text{
					Top:   10,
					Size:  12,
					Align: consts.Left,
				})
				m.Text(t.Screening.Movie.Name, props.Text{
					Top:   16,
					Size:  12,
					Align: consts.Left,
				})
				m.Text(t.Screening.StartTime.Format("3:4:5 pm, January 02 2006"), props.Text{
					Top:   22,
					Size:  12,
					Align: consts.Left,
				})
				m.Text(fmt.Sprintf("ID: %d", booking.Id), props.Text{
					Top:   28,
					Size:  12,
					Align: consts.Left,
				})
			})
			m.Col(5, func() {
				m.Text(seatInfo, props.Text{
					Top:   3,
					Size:  15,
					Style: consts.Bold,
				})
				m.QrCode(fmt.Sprintf("tran_%s_%s", t.Id, seatName), props.Rect{
					Top:     14,
					Center:  false,
					Percent: 80,
				})
			})
		})

		m.AddPage()
	}
	fileName := fmt.Sprintf("tran_%s.pdf", t.Id)
	bytesBuff, err := m.Output()

	if err != nil {
		return bytesBuff, "", err
	}

	return bytesBuff, fileName, nil
}

func AddLine(m pdf.Maroto, text string, size float64, align consts.Align) {
	m.Row(8, func() {
		m.Col(12, func() {
			m.Text(text, props.Text{
				Top:   3,
				Size:  size,
				Style: consts.Normal,
				Align: align,
				// Color: getDarkPurpleColor(),
			})
		})
	})
}

func (t *Transaction) buildHeading(m pdf.Maroto) {
	m.RegisterHeader(func() {
		m.Row(15, func() {
			m.Col(12, func() {
				m.Text("QFT Cinemas", props.Text{
					Top:   3,
					Size:  30,
					Style: consts.Bold,
					Align: consts.Center,
					Color: getDarkPurpleColor(),
				})

			})
		})
		m.Row(8, func() {
			m.Col(12, func() {
				m.Text("Entry Pass", props.Text{
					Top:   3,
					Size:  15,
					Style: consts.Bold,
					Align: consts.Center,
					Color: getDarkPurpleColor(),
				})
			})
		})
		m.Row(5, func() {
			m.Col(12, func() {
				m.Text(t.Screening.Cinema.Name, props.Text{
					Top:   3,
					Size:  10,
					Style: consts.Bold,
					Align: consts.Center,
					Color: getDarkPurpleColor(),
				})
			})
		})
		m.Row(5, func() {
			m.Col(12, func() {
				m.Text(t.Screening.Cinema.Address, props.Text{
					Top:   3,
					Size:  10,
					Style: consts.Normal,
					Align: consts.Center,
				})
			})
		})
	})
}

func getDarkPurpleColor() color.Color {
	return color.Color{
		Red:   88,
		Green: 80,
		Blue:  99,
	}
}
