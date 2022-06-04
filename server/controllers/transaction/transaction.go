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
	"gorm.io/gorm"
)

type TransactionController struct {
	controllers.BaseController
}

func NewTransactionController(config *configs.Config, db *gorm.DB) *TransactionController {
	return &TransactionController{
		BaseController: *controllers.NewBaseController(config, db),
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
