package movie

import (
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
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

	searchQuery := c.Query("q")

	query := mc.GetDb()

	if searchQuery != "" {
		query = query.Where("name @@ to_tsquery(?)", searchQuery)
	}

	err := query.Find(&movies).Error

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

	err = mc.GetDb().Where("id in (select uuid(movie_id) from screenings where start_time > now())").Find(&nowShowing).Error

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

type CreateMovieParams struct {
	Name        string `json:"name" form:"name" binding:"required,min=1"`
	Description string `json:"description" form:"description" binding:"required"`
	Banner      string `json:"banner" form:"banner" binding:"required"`
	Trailer     string `json:"trailer" form:"trailer" binding:"required"`
	Length      int    `json:"length" form:"length" binding:"required,min=1"`
	ReleaseDate string `json:"release_date" form:"release_date" binding:"required"`
}

func (mc *MovieController) CreateMovie(c *gin.Context) {
	var params CreateMovieParams

	if err := c.BindJSON(&params); err != nil {
		fmt.Println(params, err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	releaseDate, err := time.Parse("2006-01-02", params.ReleaseDate)

	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   true,
			"message": "Invalid release date",
		})
		return
	}

	res := mc.GetDb().Create(&models.Movie{
		Name:        params.Name,
		Description: params.Description,
		Banner:      params.Banner,
		Trailer:     params.Trailer,
		Length:      params.Length,
		ReleaseDate: releaseDate,
	})

	if res.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": "Error creating movie",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"error":   false,
		"message": "Success",
	})
}

type DeleteMovieParams struct {
	Id uuid.UUID `json:"id"`
}

func (mc *MovieController) DeleteMovie(c *gin.Context) {
	var params DeleteMovieParams
	if err := c.Bind(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	res := mc.GetDb().Delete(&models.Movie{}, "id = ?", params.Id)

	if res.Error != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   true,
			"message": "Error deleting movie",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"error":   false,
		"message": "Success",
	})
}
