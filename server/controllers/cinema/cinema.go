package cinema

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/overlorddamygod/qft-server/configs"
	"github.com/overlorddamygod/qft-server/controllers"
	"github.com/overlorddamygod/qft-server/models"
	"gorm.io/gorm"
)

type CinemaController struct {
	controllers.BaseController
}

func NewCinemaController(config *configs.Config, db *gorm.DB) *CinemaController {
	return &CinemaController{
		BaseController: *controllers.NewBaseController(config, db),
	}
}

type GetCinemaParams struct {
	CinemaId string `json:"id" uri:"id" binding:"required,uuid"`
}

func (cc *CinemaController) GetCinema(c *gin.Context) {
	var params GetCinemaParams
	if err := c.BindUri(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	var cinema models.Cinema

	err := cc.GetDb().First(&cinema, "id = ?", params.CinemaId).Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{
				"error":   true,
				"message": "Cinema not found",
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
		"data":    cinema,
	})
}

func (cc *CinemaController) GetCinemas(c *gin.Context) {
	var cinemas []models.Cinema

	getAuditoriums := c.Query("auditorium") == "1"

	var query *gorm.DB = cc.GetDb()

	if getAuditoriums {
		query = query.Preload("Auditoriums")
	}

	err := query.Find(&cinemas).Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{
				"error":   true,
				"message": "Cinemas not found",
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
		"data":    cinemas,
	})
}
