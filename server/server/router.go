package server

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/overlorddamygod/qft-server/configs"
	"go.uber.org/fx"
)

func NewRouter(lc fx.Lifecycle, config *configs.Config) *gin.Engine {
	router := gin.New()

	lc.Append(fx.Hook{
		OnStart: func(context.Context) error {
			PORT := os.Getenv("PORT")

			if PORT == "" {
				PORT = "8080"
			}

			if err := router.Run(":" + PORT); err != nil {
				return err
			}
			log.Println("Server started on port " + PORT)
			return nil
		},
		OnStop: func(ctx context.Context) error {
			fmt.Println("Stopping QFT Server.")
			return nil
		},
	})
	return router
}
