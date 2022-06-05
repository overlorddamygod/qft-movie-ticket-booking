package transaction

import (
	"database/sql"
	"errors"
	"fmt"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/overlorddamygod/qft-server/configs"
	"github.com/overlorddamygod/qft-server/controllers"
	"github.com/overlorddamygod/qft-server/models"
	storage_go "github.com/overlorddamygod/storage-go"
	stripe "github.com/stripe/stripe-go/v72"
	"github.com/stripe/stripe-go/v72/paymentintent"
	"gorm.io/gorm"
)

type TransactionController struct {
	controllers.BaseController
	storage *storage_go.Client
}

func NewTransactionController(config *configs.Config, db *gorm.DB, storage *storage_go.Client) *TransactionController {
	return &TransactionController{
		BaseController: *controllers.NewBaseController(config, db),
		storage:        storage,
	}
}

type GetOrCreateTransactionParams struct {
	ScreeningID int `json:"screening_id" binding:"required"`
}

func (tc *TransactionController) GetOrCreateTransaction(c *gin.Context) {
	userUuid, err := tc.GetUserUUid(c)
	if err != nil {
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Invalid user id",
		})
		return
	}

	var params GetOrCreateTransactionParams
	if err := c.Bind(&params); err != nil {
		fmt.Println(err)
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	var transaction models.Transaction

	err = tc.GetDb().Transaction(func(tx *gorm.DB) error {
		result := tx.First(&transaction, "user_id = ? AND screening_id = ? AND expires_at > now()", userUuid, params.ScreeningID)

		if result.Error != nil {
			if errors.Is(result.Error, gorm.ErrRecordNotFound) {
				transaction.UserId = userUuid
				transaction.ScreeningId = params.ScreeningID
				transaction.CreatedAt = time.Now()
				transaction.ExpiresAt = transaction.CreatedAt.Add(15 * time.Minute)

				result = tx.Create(&transaction)

				if result.Error != nil {
					return result.Error
				}
			} else {
				return errors.New("server error")
			}
		}

		fmt.Println("TRANSACTIONS: ", transaction)
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
		"error": false,
		"data":  transaction,
	})
}

type PayParams struct {
	TransactionID string `json:"transaction_id" binding:"required"`
	Amount        int64  `json:"amount" binding:"required"`
}

func (tc *TransactionController) Pay(c *gin.Context) {
	var bodyParams PayParams
	if err := c.Bind(&bodyParams); err != nil {
		fmt.Println(err)
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	stripe.Key = tc.BaseController.GetConfig().Stripe.SecretKey

	var transaction models.Transaction

	var pi *stripe.PaymentIntent

	err := tc.GetDb().Transaction(func(tx *gorm.DB) error {
		result := tx.Preload("Bookings").Preload("Bookings.Seat").First(&transaction, `transactions.id = ?`, bodyParams.TransactionID)

		if result.Error != nil {
			if errors.Is(result.Error, gorm.ErrRecordNotFound) {
				return errors.New("transaction not found")
			} else {
				return errors.New("server error")
			}
		}

		if transaction.Paid {
			return errors.New("transaction already paid")
		}

		if transaction.IsExpired() {
			return errors.New("transaction expired")
		}

		var totalPrice int64

		for _, booking := range transaction.Bookings {
			totalPrice += booking.Seat.Price
		}

		params := &stripe.PaymentIntentParams{
			Amount:   stripe.Int64(totalPrice * 100),
			Currency: stripe.String(string(stripe.CurrencyNPR)),
			PaymentMethodTypes: []*string{
				stripe.String("card"),
			},
		}

		paymentIntent, err := paymentintent.New(params)

		pi = paymentIntent

		if err != nil {
			return err
		}

		if err := tx.Model(transaction).Updates(map[string]interface{}{
			"payment_intent_id": pi.ID,
			"total_price":       totalPrice,
		}).Error; err != nil {
			return err
		}

		return nil
	}, &sql.TxOptions{
		Isolation: sql.LevelSerializable,
	})

	if err != nil {
		// paymentintent.Cancel(pi.ID, nil)
		c.JSON(400, gin.H{
			"error":   true,
			"message": err.Error(),
		})
		return
	}

	c.JSON(200, gin.H{
		"error": false,
		"data": gin.H{
			"payment_intent_id": pi.ID,
			"client_secret":     pi.ClientSecret,
		},
	})
}

type ConfirmPaymentParams struct {
	PaymentIntentID string `json:"payment_intent_id" binding:"required"`
	TransactionID   string `json:"transaction_id" binding:"required"`
}

func (tc *TransactionController) ConfirmPayment(c *gin.Context) {
	var bodyParams ConfirmPaymentParams
	if err := c.Bind(&bodyParams); err != nil {
		fmt.Println(err)
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	stripe.Key = tc.BaseController.GetConfig().Stripe.SecretKey

	pi, err := paymentintent.Get(bodyParams.PaymentIntentID, nil)

	if err != nil {
		fmt.Println(err)
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Invalid payment intent id",
		})
		return
	}

	if pi.Status != "succeeded" {
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Payment intent not succeeded",
		})
		return
	}

	err = tc.GetDb().Transaction(func(tx *gorm.DB) error {
		var transaction models.Transaction
		result := tx.First(&transaction, "id = ? AND payment_intent_id = ?", bodyParams.TransactionID, bodyParams.PaymentIntentID)

		if result.Error != nil {
			if errors.Is(result.Error, gorm.ErrRecordNotFound) {
				return errors.New("transaction not found")
			} else {
				return errors.New("server error")
			}
		}

		if err := tx.Model(transaction).Updates(map[string]interface{}{
			"paid":       true,
			"expires_at": time.Now(),
		}).Error; err != nil {
			return err
		}

		if err := tx.Model(&models.Booking{}).Where("transaction_id = ?", bodyParams.TransactionID).Update("status", 4).Error; err != nil {
			return err
		}
		var newTransaction models.Transaction
		if err := tc.GetDb().Preload("Bookings").Preload("Bookings.Seat").Preload("Screening").Preload("Screening.Auditorium").Preload("Screening.Movie").Preload("Screening.Cinema").First(&newTransaction, "id = ?", bodyParams.TransactionID).Error; err != nil {
			return err
		}

		bytesBuff, fileName, err := newTransaction.BuildReceipt()

		if err != nil {
			return errors.New("server error")
		}

		tc.storage.UploadFile("transactions-receipts", fileName, &bytesBuff, "application/pdf")

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
		"error": false,
		"data": gin.H{
			"payment_intent_id": pi.ID,
			"transaction_id":    bodyParams.TransactionID,
			"success":           true,
		},
	})
}

func (tc *TransactionController) GetUserTransactions(c *gin.Context) {
	userUUID, err := tc.GetUserUUid(c)

	if err != nil {
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Invalid user",
		})
		return
	}

	var transactions []models.Transaction
	if err := tc.GetDb().Preload("Bookings").Preload("Bookings.Seat").Preload("Screening").Preload("Screening.Auditorium").Preload("Screening.Movie").Preload("Screening.Cinema").Find(&transactions, "user_id = ? AND paid = true", userUUID).Error; err != nil {
		c.JSON(400, gin.H{
			"error":   true,
			"message": err.Error(),
		})
		return
	}

	c.JSON(200, gin.H{
		"error": false,
		"data":  transactions,
	})
}

type GetUserTransactionParams struct {
	TransactionId string `json:"transaction_id" uri:"transaction_id" binding:"required"`
}

func (tc *TransactionController) GetUserTransaction(c *gin.Context) {
	userUUID, err := tc.GetUserUUid(c)

	if err != nil {
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Invalid user",
		})
		return
	}

	var params GetUserTransactionParams

	if err := c.BindUri(&params); err != nil {
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	var transaction models.Transaction
	if err := tc.GetDb().Preload("Bookings").Preload("Bookings.Seat").Preload("Screening").Preload("Screening.Auditorium").Preload("Screening.Movie").Preload("Screening.Cinema").First(&transaction, "id = ? AND user_id = ? AND paid = true", params.TransactionId, userUUID).Error; err != nil {
		c.JSON(400, gin.H{
			"error":   true,
			"message": err.Error(),
		})
		return
	}

	c.JSON(200, gin.H{
		"error": false,
		"data":  transaction,
	})
}
