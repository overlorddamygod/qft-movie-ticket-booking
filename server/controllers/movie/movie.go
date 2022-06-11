package movie

import (
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/overlorddamygod/qft-server/configs"
	"github.com/overlorddamygod/qft-server/controllers"
	"github.com/overlorddamygod/qft-server/models"
	"gorm.io/gorm"
)

type MovieController struct {
	controllers.BaseController
}

func NewMovieController(config *configs.Config, db *gorm.DB) *MovieController {
	return &MovieController{
		BaseController: *controllers.NewBaseController(config, db),
	}
}

type GetMovieParams struct {
	MovieId string `json:"id" uri:"id" binding:"required,uuid"`
}

func (mc *MovieController) GetMovie(c *gin.Context) {
	var params GetMovieParams
	if err := c.BindUri(&params); err != nil {
		fmt.Println(params, err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	var movie models.Movie

	err := mc.GetDb().First(&movie, "id = ?", params.MovieId).Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{
				"error":   true,
				"message": "Movie not found",
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
		"data":    movie,
	})
}

func (mc *MovieController) GetMovies(c *gin.Context) {
	var movies []models.Movie

	err := mc.GetDb().Find(&movies).Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{
				"error":   true,
				"message": "Movies not found",
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
		"data":    movies,
	})
}

func (mc *MovieController) GetHomeMovies(c *gin.Context) {
	var movies []models.Movie

	err := mc.GetDb().Find(&movies).Error

	if err != nil {
		if err == gorm.ErrRecordNotFound {
			c.JSON(http.StatusNotFound, gin.H{
				"error":   true,
				"message": "Movies not found",
			})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": "Server error",
		})
		return
	}

	var nowShowing []models.Movie

	err = mc.GetDb().Where("id in (select movie_id from screenings where start_time > now())").Find(&nowShowing).Error

	if err != nil {
		if err != gorm.ErrRecordNotFound {
			c.JSON(http.StatusInternalServerError, gin.H{
				"error":   true,
				"message": "Server error",
			})
			return
		}
	}

	c.JSON(http.StatusOK, gin.H{
		"error":   false,
		"message": "",
		"data": gin.H{
			"movies":     movies,
			"nowShowing": nowShowing,
		},
	})
}
