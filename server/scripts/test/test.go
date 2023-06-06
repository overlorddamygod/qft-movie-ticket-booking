package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math/rand"
	"net/http"
	"sync"
	"time"
)

func getRandomSeat(min, max int) int {
	rand.Seed(time.Now().UnixNano())

	return rand.Intn(max-min+1) + min
}

var userToken []string = []string{"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eV90eXBlIjoiZW1haWwiLCJ1c2VyX2lkIjoiZjQyNzY0MmUtMWU2Yy00MWMzLTk3OTQtYThhOWMyMTliMjMxIiwiZW1haWwiOiJ0ZXN0NUBnbWFpbC5jb20iLCJleHAiOjE2ODU5NDcyMTl9.8dYrkkmxydwhcrIRu8YrTf6OlDayhQlySmUKzbzXhAM", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eV90eXBlIjoiZW1haWwiLCJ1c2VyX2lkIjoiNzMxMTZmOTAtYjRkNy00ZjkwLWJhNGEtNTUxNjlhNWE4OGY0IiwiZW1haWwiOiJ0ZXN0M0BnbWFpbC5jb20iLCJleHAiOjE2ODU5NDcyMTh9.AdfZt98yoththjZ9LYTk8WjYJVtwCBU6j9Ys5idN4Ks", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eV90eXBlIjoiZW1haWwiLCJ1c2VyX2lkIjoiODdjODkxZTItM2EzMS00MDE2LWI0NTQtMTA0N2ZjZTJhZTgzIiwiZW1haWwiOiJ0ZXN0MEBnbWFpbC5jb20iLCJleHAiOjE2ODU5NDcyMTd9.PQDsAbEeIoSWX4BoC-v9shPYUJ3U5MCCREWCJPIC1IE", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eV90eXBlIjoiZW1haWwiLCJ1c2VyX2lkIjoiNmJkMDI3NjQtNzhhYy00MTIxLThlMmUtN2I4ZTMxNTJmZTlhIiwiZW1haWwiOiJ0ZXN0MUBnbWFpbC5jb20iLCJleHAiOjE2ODU5NDcyMTd9.FY76y9eoIGzsOZEaXqMynpSlE8OR7zmPFN_PL57KNgU", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGl0eV90eXBlIjoiZW1haWwiLCJ1c2VyX2lkIjoiNzY0YzY3MWUtNzkyOS00OTZjLWIzNGYtM2MwYmU3ZDkzOTI3IiwiZW1haWwiOiJ0ZXN0MkBnbWFpbC5jb20iLCJleHAiOjE2ODU5NDcyMTh9.DVZIa6FEMbP-8w6R1vjKfMyRtAUs8tuXQTI5Y--FIIw"}

func getRandomUser(users []User) User {
	rand.Seed(time.Now().UnixNano())
	randomIndex := rand.Intn(len(users))
	return users[randomIndex]
}

type User struct {
	Name         string `json:"name"`
	Email        string `json:"email"`
	Password     string `json:"password"`
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
}

func getUsers(path string) ([]User, error) {
	fileBytes, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, err
	}

	var users []User

	err = json.Unmarshal(fileBytes, &users)
	if err != nil {
		return nil, err
	}

	return users, nil
}

func main() {
	users, err := getUsers("../users.json")

	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	var wg sync.WaitGroup
	for i := 0; i < 200; i++ {
		wg.Add(1)
		// index := i
		go func(index int) {
			defer wg.Done()

			var seat_id int = getRandomSeat(343, 452)

			user := getRandomUser(users)

			fmt.Printf("\n#%d user: %s seatid: %d", index, user, seat_id)

			var buffer bytes.Buffer
			json.NewEncoder(&buffer).Encode(map[string]interface{}{"seat_id": seat_id, "screening_id": 3})

			req, err := http.NewRequest(http.MethodPost, "http://localhost:8081/api/v1/booking", &buffer)
			req.Header.Set("Content-Type", "application/json")
			req.Header.Set("Authorization", user.AccessToken)

			client := &http.Client{}
			resp, err := client.Do(req)
			if err != nil {
				fmt.Println(i, "Error Sending Req", err)
				return
			}
			defer resp.Body.Close()

			response, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				fmt.Println(i, "Error:", err)
				return
			}

			fmt.Println("RES", resp.StatusCode, string(response))
		}(i)
	}

	wg.Wait()
}
