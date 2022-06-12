package auditorium

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/overlorddamygod/qft-server/configs"
	"github.com/overlorddamygod/qft-server/controllers"
	"github.com/overlorddamygod/qft-server/models"
	"gorm.io/gorm"
)

type AuditoriumController struct {
	controllers.BaseController
}

func NewAuditoriumController(config *configs.Config, db *gorm.DB) *AuditoriumController {
	return &AuditoriumController{
		BaseController: *controllers.NewBaseController(config, db),
	}
}

type GetAuditoriumParams struct {
	AuditoriumId string `json:"id" uri:"id" binding:"required,uuid"`
}

func (ac *AuditoriumController) GetAuditorium(c *gin.Context) {
	var params GetAuditoriumParams
	if err := c.BindUri(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	var auditorium models.Auditorium

	err := ac.GetDb().First(&auditorium, "id = ?", params.AuditoriumId).Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{
				"error":   true,
				"message": "Auditorium not found",
			})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": "Server error",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"error":   false,
		"message": "",
		"data":    auditorium,
	})
}

type CustomizeSeatURI struct {
	AuditoriumId int `json:"audi_id" uri:"audi_id" binding:"required"`
}

type CustomizeSeatParams struct {
	Rows    int           `json:"rows" binding:"required"`
	Columns int           `json:"columns" binding:"required"`
	Seats   []models.Seat `json:"seats" binding:"required"`
}

func (ac *AuditoriumController) CustomizeSeat(c *gin.Context) {
	var uriParams CustomizeSeatURI

	if err := c.BindUri(&uriParams); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	var params CustomizeSeatParams

	if err := c.Bind(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	err := ac.GetDb().Transaction(func(tx *gorm.DB) error {
		auditorium := models.Auditorium{
			Id: uriParams.AuditoriumId,
		}

		if err := tx.Model(&auditorium).Updates(models.Auditorium{
			Rows:    params.Rows,
			Columns: params.Columns,
		}).Error; err != nil {
			return err
		}

		if err := tx.Where("auditorium_id = ?", uriParams.AuditoriumId).Delete(&models.Seat{}).Error; err != nil {
			return err
		}

		if err := tx.Create(&params.Seats).Error; err != nil {
			return err
		}

		return nil
	})

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": "Error creating seats",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"error":   false,
		"message": "",
	})
}
