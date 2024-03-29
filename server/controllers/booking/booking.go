package booking

import (
	"database/sql"
	"errors"
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/overlorddamygod/qft-server/configs"
	"github.com/overlorddamygod/qft-server/controllers"
	TransactionController "github.com/overlorddamygod/qft-server/controllers/transaction"
	"github.com/overlorddamygod/qft-server/models"
	"gorm.io/gorm"
)

type BookingController struct {
	controllers.BaseController
}

func NewBookingController(config *configs.Config, db *gorm.DB) *BookingController {
	return &BookingController{
		BaseController: *controllers.NewBaseController(config, db),
	}
}

type CreateBookingParams struct {
	SeatID int `json:"seat_id" binding:"required"`
	// AuditoriumID int `json:"auditorium_id" binding:"required"`
	ScreeningID int `json:"screening_id" binding:"required"`
	// Status       int8   `json:"status" binding:"required"`
}

func (bc *BookingController) CreateBooking(c *gin.Context) {
	var params CreateBookingParams
	if err := c.Bind(&params); err != nil {
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	var transaction models.Transaction

	userUUID, err := bc.GetUserUUid(c)

	if err != nil {
		c.JSON(401, gin.H{
			"error":   true,
			"message": "Unauthorized",
		})
		return
	}

	bookedStatus := "booked"

	var seat models.Seat
	result := bc.GetDb().First(&seat, "id = ?", params.SeatID)

	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			c.JSON(404, gin.H{
				"error":   true,
				"message": "seat not found",
			})
			return
		}

		c.JSON(500, gin.H{
			"error":   true,
			"message": "error getting seat",
		})
		return
	}

	if !seat.Available {
		c.JSON(404, gin.H{
			"error":   true,
			"message": "seat not available",
		})
		return
	}
	t, err := TransactionController.GetCreateTransaction(bc.GetDb(), userUUID, params.ScreeningID)
	transaction = t

	if err != nil {
		c.JSON(500, gin.H{
			"error":   true,
			"message": err.Error(),
		})
		return
	}

	fmt.Println("TRANSACTIONS: ", transaction)

	err = bc.GetDb().Transaction(func(tx *gorm.DB) error {
		if err := tx.First(&models.Screening{}, "id = ? AND start_time > now()", params.ScreeningID).Error; err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				return errors.New("screening not found")
			}

			return errors.New("error getting screening")
		}

		var booked models.Booking
		result = tx.Joins("Transaction").First(&booked, `seat_id = ? AND bookings.screening_id = ? AND ("Transaction".expires_at > now() OR "Transaction".paid = true)`, params.SeatID, params.ScreeningID)
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
				ScreeningId:   params.ScreeningID,
				TransactionId: transaction.Id,
				UserId:        userUUID,
				Status:        2,
			}
			if err := tx.Create(&booking).Error; err != nil {
				return err
			}
			return nil
		}
		fmt.Println("ALREADY BOOKED")

		if booked.Transaction.Paid {
			return errors.New("seat is not available")
		}

		if booked.UserId == userUUID {
			if booked.Transaction.IsExpired() {
				return errors.New("transaction is expired")
			}

			if booked.Status == 2 {
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
