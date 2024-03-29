package server

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"github.com/overlorddamygod/qft-server/configs"
	"github.com/overlorddamygod/qft-server/controllers/auditorium"
	"github.com/overlorddamygod/qft-server/controllers/booking"
	"github.com/overlorddamygod/qft-server/controllers/cinema"
	"github.com/overlorddamygod/qft-server/controllers/movie"
	"github.com/overlorddamygod/qft-server/controllers/screening"
	"github.com/overlorddamygod/qft-server/controllers/transaction"
	"github.com/overlorddamygod/qft-server/middlewares"
	storage_go "github.com/overlorddamygod/storage-go"
	"gorm.io/gorm"
)

func RegisterServer(config *configs.Config, db *gorm.DB, storage *storage_go.Client, router *gin.Engine) {
	router.Use(cors.New(cors.Config{
		AllowOrigins: []string{"*"},
		AllowHeaders: []string{"content-type", "accept", "access-control-allow-origin", "origin", "authorization"},
	}))
	router.Use(gin.Logger())
	router.Use(gin.Recovery())

	v1 := router.Group("api/v1")
	{
		v1.Use(func(c *gin.Context) {
			c.Writer.Header().Set("Content-Type", "application/json")
			c.Next()
		})
		middlewares := middlewares.NewMiddlewares(db)

		transactionGroup := v1.Group("transaction")
		{
			transactionC := transaction.NewTransactionController(config, db, storage)
			transactionGroup.Use(middlewares.IsLoggedIn())
			transactionGroup.POST("", transactionC.GetOrCreateTransaction)
			transactionGroup.GET("", transactionC.GetUserTransactions)
			transactionGroup.GET("/:transaction_id", transactionC.GetUserTransaction)
			transactionGroup.POST("pay", transactionC.Pay)
			transactionGroup.POST("confirm", transactionC.ConfirmPayment)
		}

		screeningGroup := v1.Group("screening")
		{
			screeningC := screening.NewScreeningController(config, db)

			screeningGroup.GET("", screeningC.GetScreenings)
			screeningGroup.GET("/:id", middlewares.IsLoggedIn(), screeningC.GetScreening)

			screeningGroup.POST("", middlewares.IsLoggedIn(), middlewares.IsAdmin(), screeningC.CreateScreening)
			screeningGroup.POST("/delete", middlewares.IsLoggedIn(), middlewares.IsAdmin(), screeningC.DeleteScreening)
		}
		bookingGroup := v1.Group("booking")
		{
			bookingC := booking.NewBookingController(config, db)
			// bookingGroup.Use(middlewares.IsLoggedIn())
			bookingGroup.POST("", middlewares.IsLoggedIn(), bookingC.CreateBooking)
		}

		cinemaGroup := v1.Group("cinema")
		{
			cinemaC := cinema.NewCinemaController(config, db)
			// cinemaGroup.Use(middlewares.IsLoggedIn())
			cinemaGroup.GET("/:id", cinemaC.GetCinema)
			cinemaGroup.GET("", cinemaC.GetCinemas)
		}

		auditoriumGroup := v1.Group("auditorium")
		{
			audiC := auditorium.NewAuditoriumController(config, db)

			auditoriumGroup.POST("/:audi_id/seats", middlewares.IsLoggedIn(), middlewares.IsAdmin(), audiC.CustomizeSeat)
			auditoriumGroup.POST("/delete", middlewares.IsLoggedIn(), middlewares.IsAdmin(), audiC.DeleteAuditorium)
		}

		movieGroup := v1.Group("movie")
		{
			movieC := movie.NewMovieController(config, db)
			movieGroup.POST("", middlewares.IsLoggedIn(), middlewares.IsAdmin(), movieC.CreateMovie)
			movieGroup.POST("/delete", middlewares.IsLoggedIn(), middlewares.IsAdmin(), movieC.DeleteMovie)

			// cinemaGroup.Use(middlewares.IsLoggedIn())
			movieGroup.GET("/:id", movieC.GetMovie)
			movieGroup.GET("", movieC.GetMovies)
			movieGroup.GET("/home", movieC.GetHomeMovies)
		}
	}
}
