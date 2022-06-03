package screening

import (
	"errors"
	"fmt"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/overlorddamygod/qft-server/configs"
	"github.com/overlorddamygod/qft-server/models"
	"gorm.io/gorm"
)

type ScreeningController struct {
	config *configs.Config
	db     *gorm.DB
}

func NewScreeningController(config *configs.Config, db *gorm.DB) *ScreeningController {
	return &ScreeningController{
		config: config,
		db:     db,
	}
}

type GetScreeningParams struct {
	ScreeningId string `json:"screening_id" uri:"screening_id" binding:"required"`
}

func (sc *ScreeningController) GetScreening(c *gin.Context) {
	user_id, _ := c.Get("user_id")

	// conevrt user_id to uuid
	user_uuid, _ := uuid.Parse(user_id.(string))

	// userid := 2
	var params GetScreeningParams
	if err := c.BindUri(&params); err != nil {
		fmt.Println(err)
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	var screening models.Screening

	err := sc.db.Joins("Auditorium").Preload("Auditorium.Seats").Find(&screening, "screenings.id = ?", params.ScreeningId).Error

	if err != nil {
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Server error",
		})
		return
	}

	// sc.db.Find()
	var booked []models.Booking

	result := sc.db.Joins("Transaction").Find(&booked, `auditorium_id = ? AND bookings.screening_id = ? AND "Transaction".expires_at > now()`, screening.AuditoriumId, screening.Id)

	if result.Error != nil {
		if !errors.Is(result.Error, gorm.ErrRecordNotFound) {
			c.JSON(400, gin.H{
				"error":   true,
				"message": "Server error",
			})
			return
		}
	}

	// make map of the booked where id is key
	bookedMap := make(map[int]models.Booking)
	for _, b := range booked {
		bookedMap[b.SeatId] = b
	}

	fmt.Println(bookedMap)
	// loop between screening.auditorium.seats

	for i, seat := range screening.Auditorium.Seats {
		refSeat := (&screening.Auditorium.Seats[i])
		if seat.Available {
			refSeat.Status = 1
		} else {
			refSeat.Status = 0
		}

		val, ok := bookedMap[seat.Id]
		if ok {
			fmt.Println(val, ok)
			fmt.Println("SETTING", val.Status)

			// if val.UserId == user_id {
			// 	refSeat.Status = val.Status
			// } else {
			// 	refSeat.Status = 3
			// }
			if val.Status == 2 {
				fmt.Println(val.UserId, user_id, val.UserId == user_uuid)
				if val.UserId == user_uuid {
					refSeat.Status = val.Status
				} else {
					refSeat.Status = 3
				}
			}
			// (&seat).Status = val.Status
		}
	}

	for _, seat := range screening.Auditorium.Seats {
		if seat.Id == 572 {

			fmt.Println(seat)
		}
	}

	c.JSON(200, gin.H{
		"error":   false,
		"message": "Success",
		"data":    screening,
	})
}

type GetScreeningsParams struct {
	MovieId  string `json:"movie_id" form:"movie_id" binding:"required"`
	CinemaId string `json:"cinema_id" form:"cinema_id" binding:"required"`
	Date     string `json:"date" form:"date"`
}

func (sc *ScreeningController) GetScreenings(c *gin.Context) {
	var params GetScreeningsParams
	if err := c.BindQuery(&params); err != nil {
		fmt.Println(err)
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	if params.Date == "" {
		params.Date = time.Now().Format("2006-01-02")
	}

	startDate, error := time.Parse("2006-01-02", params.Date)

	if error != nil {
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Invalid params",
		})
		return
	}

	endDate := startDate.Add(24 * time.Hour)

	fmt.Println(params, startDate, endDate)

	var screenings []models.Screening

	err := sc.db.Joins("Auditorium").Where("movie_id = ? AND screenings.cinema_id = ? AND start_time < ? AND start_time > ?", params.MovieId, params.CinemaId, endDate, startDate).Find(&screenings).Error

	if err != nil {
		c.JSON(400, gin.H{
			"error":   true,
			"message": "Server error",
		})
		return
	}

	c.JSON(200, gin.H{
		"error":   false,
		"message": "Success",
		"data":    screenings,
	})
}