package main

import (
	"context"
	"log"

	"github.com/overlorddamygod/qft-server/configs"
	"github.com/overlorddamygod/qft-server/controllers/booking"
	"github.com/overlorddamygod/qft-server/controllers/screening"
	"github.com/overlorddamygod/qft-server/db"
	"github.com/overlorddamygod/qft-server/server"
	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"
)

func main() {
	app := fx.New(
		fx.Provide(
			configs.NewConfig(".env"),
			db.NewDB,
			booking.NewBookingController,
			screening.NewScreeningController,
			server.NewRouter,
		),
		fx.Populate(&configs.MainConfig),
		fx.Invoke(server.RegisterServer),
		fx.WithLogger(
			func() fxevent.Logger {
				return fxevent.NopLogger
			},
		),
	)

	startCtx := context.Background()

	if err := app.Start(startCtx); err != nil {
		log.Fatal(err)
	}

	// <-app.Done()
}
