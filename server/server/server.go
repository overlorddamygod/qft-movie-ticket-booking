package server

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/overlorddamygod/qft-server/configs"
	"github.com/overlorddamygod/qft-server/controllers/booking"
	"github.com/overlorddamygod/qft-server/controllers/screening"
	"github.com/overlorddamygod/qft-server/middlewares"
)

func RegisterServer(config *configs.Config, router *gin.Engine, bookingC *booking.BookingController, screeningC *screening.ScreeningController) {
	router.Use(cors.New(cors.Config{
		AllowOrigins: []string{"*"},
		AllowHeaders: []string{"content-type", "accept", "access-control-allow-origin", "origin", "authorization"},
	}))
	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	v1 := router.Group("api/v1")
	{
		screeningGroup := v1.Group("screening")
		{
			screeningGroup.Use(middlewares.IsLoggedIn())
			screeningGroup.GET("", screeningC.GetScreenings)
			screeningGroup.GET("/:screening_id", screeningC.GetScreening)
		}
		bookingGroup := v1.Group("booking")
		{
			bookingGroup.Use(func(c *gin.Context) {
				c.Writer.Header().Set("Content-Type", "application/json")
				c.Next()
			})

			bookingGroup.POST("", bookingC.CreateBooking)
		}
	}
}