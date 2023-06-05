package booking_test

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"sync"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/overlorddamygod/qft-server/configs"
	"github.com/overlorddamygod/qft-server/db"
	"github.com/overlorddamygod/qft-server/server"
	"github.com/overlorddamygod/qft-server/storage"
	"go.uber.org/fx"
	"go.uber.org/fx/fxevent"
	"gorm.io/gorm"
)

func TestConcurrency(t *testing.T) {
	var dbConn *gorm.DB
	var router *gin.Engine

	_ = fx.New(
		fx.Provide(
			configs.NewConfig("../../.env"),
			db.NewDB,
			storage.NewStorage,
			// booking.NewBookingController,
			// screening.NewScreeningController,
			// transaction.NewTransactionController,
			server.NewRouter,
		),
		fx.Populate(&dbConn),
		fx.Populate(&router),
		fx.Populate(&configs.MainConfig),
		fx.Invoke(server.RegisterServer),
		fx.WithLogger(
			func() fxevent.Logger {
				return fxevent.NopLogger
			},
		),
	)

	var userToken []string = []string{"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eV90eXBlIjoiZW1haWwiLCJ1c2VyX2lkIjoiODdjODkxZTItM2EzMS00MDE2LWI0NTQtMTA0N2ZjZTJhZTgzIiwiZW1haWwiOiJ0ZXN0MEBnbWFpbC5jb20iLCJleHAiOjE2ODU5NDcyMTd9.PQDsAbEeIoSWX4BoC-v9shPYUJ3U5MCCREWCJPIC1IE"}

	var wg sync.WaitGroup
	for i := 0; i < 20; i++ {
		wg.Add(1)
		// index := i
		go func(index int) {
			defer wg.Done()

			var buffer bytes.Buffer

			var seat_id int = 344

			if index%2 == 1 {
				seat_id = seat_id + ((index - 1) / 2)
			} else {
				seat_id = seat_id + (index / 2)
			}

			fmt.Printf("\n#%d user: %d seatid: %d", index, index%2, seat_id)

			json.NewEncoder(&buffer).Encode(map[string]interface{}{"seat_id": seat_id, "screening_id": 2, "auditorium_id": 1})

			req := httptest.NewRequest(http.MethodPost, "/api/v1/booking", &buffer)
			req.Header.Set("Content-Type", "application/json")
			req.Header.Set("Authorization", userToken[index%2])
			w := httptest.NewRecorder()
			router.ServeHTTP(w, req)

			if w.Code != 200 {
				t.Errorf("expected 200, got %d user %d", w.Code, index%2)
			}

			fmt.Println(w.Body.String())
		}(i)
	}

	wg.Wait()

	// req := httptest.NewRequest(http.MethodPost, "/api/v1/booking", &buffer)
	// req.Header.Set("Content-Type", "application/json")
	// req.

	// // Setup response recorder
	// w := httptest.NewRecorder()

	// router.ServeHTTP(w, req)

	// // var response SigninResponse

	// // assert.NoError(ts.T(), json.NewDecoder(w.Body).Decode(&response))
	// // fmt.Println(response)
	// // ts.T().Log(response)
	// // assert.Equal(ts.T(), http.StatusNotFound, w.Code)
}
