package booking

import (
	"database/sql"
	"errors"
	"fmt"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/overlorddamygod/qft-server/configs"
	"github.com/overlorddamygod/qft-server/models"
	"gorm.io/gorm"
)

type BookingController struct {
	config *configs.Config
	db     *gorm.DB
}

func NewBookingController(config *configs.Config, db *gorm.DB) *BookingController {
	return &BookingController{
		config: config,
		db:     db,
	}
}

type CreateBookingParams struct {
	UserID       uuid.UUID `json:"user_id" binding:"required"`
	SeatID       int       `json:"seat_id" binding:"required"`
	AuditoriumID int       `json:"auditorium_id" binding:"required"`
	ScreeningID  int       `json:"screening_id" binding:"required"`
	// Status       int8   `json:"status" binding:"required"`
}

func (bc *BookingController) CreateBooking(c *gin.Context) {
	var params CreateBookingParams
	if err := c.Bind(&params); err != nil {
		fmt.Println(err)
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	fmt.Println(params)
	var transaction models.Transaction

	// userUUID, err := uuid.Parse(params.UserID)

	bookedStatus := "booked"

	err := bc.db.Transaction(func(tx *gorm.DB) error {
		var seat models.Seat
		result := tx.First(&seat, "id = ?", params.SeatID)

		if result.Error != nil {
			if errors.Is(result.Error, gorm.ErrRecordNotFound) {
				return errors.New("seat not found")
			}

			return errors.New("error getting seat")
		}

		if !seat.Available {
			return errors.New("seat is not available")
		}

		result = tx.First(&transaction, "user_id = ? AND screening_id = ? AND expires_at > now()", params.UserID, params.ScreeningID)

		if result.Error != nil {
			if errors.Is(result.Error, gorm.ErrRecordNotFound) {
				transaction.UserId = params.UserID
				transaction.ScreeningId = params.ScreeningID
				transaction.CreatedAt = time.Now()
				transaction.ExpiresAt = transaction.CreatedAt.Add(30 * time.Minute)

				result = tx.Create(&transaction)

				if result.Error != nil {
					return result.Error
				}
			} else {
				return result.Error
			}
		}

		fmt.Println("TRANSACTIONS: ", transaction)

		if err := tx.First(&models.Screening{}, "id = ? AND start_time > now()", params.ScreeningID).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				return errors.New("screening not found")
			}

			return errors.New("error getting screening")
		}

		var booked models.Booking
		result = tx.Joins("Transaction").First(&booked, `seat_id = ? AND auditorium_id = ? AND bookings.screening_id = ? AND ("Transaction".expires_at > now() OR "Transaction".paid = true)`, params.SeatID, params.AuditoriumID, params.ScreeningID)
		if result.Error != nil {
			if result.Error != gorm.ErrRecordNotFound {
				return result.Error
			}

			var bookingCount int64
			result = tx.Model(&models.Booking{}).Where("transaction_id = ?", transaction.Id).Count(&bookingCount)

			if result.Error != nil {
				return result.Error
			}

			if bookingCount >= 8 {
				return errors.New("max bookings reached")
			}

			booking := models.Booking{
				SeatId:        params.SeatID,
				AuditoriumId:  params.AuditoriumID,
				ScreeningId:   params.ScreeningID,
				TransactionId: transaction.Id,
				UserId:        params.UserID,
				Status:        2,
			}
			if err := tx.Create(&booking).Error; err != nil {
				fmt.Println("SAD", booking)
				fmt.Println(err)
				return err
			}
			return nil
		}
		fmt.Println("ALREADY BOOKED")

		if booked.Transaction.Paid {
			return errors.New("seat is not available")
		}

		if booked.UserId == params.UserID {
			fmt.Println("HERE")
			if booked.Transaction.IsExpired() {
				return errors.New("transaction is expired")
			}
			fmt.Println("SAD")

			if booked.Status == 2 {
				fmt.Println("DELETING")
				result := tx.Delete(&booked)

				bookedStatus = "unbooked"
				if result.Error != nil {
					return result.Error
				}
			}

			return nil
		}

		if !booked.Transaction.IsExpired() {
			return errors.New("seat is already booked")
		}
		return nil
	}, &sql.TxOptions{
		Isolation: sql.LevelSerializable,
	})

	if err != nil {
		c.JSON(400, gin.H{
			"error":   true,
			"message": err.Error(),
		})
		return
	}

	c.JSON(200, gin.H{
		"error":   false,
		"message": bookedStatus,
	})
}
