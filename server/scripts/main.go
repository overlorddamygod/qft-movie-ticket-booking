package main

import (
	"bytes"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"github.com/goccy/go-json"
)

type User struct {
	Name         string `json:"name"`
	Email        string `json:"email"`
	Password     string `json:"password"`
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
}

type SignInUser struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

type SignInResponse struct {
	Error        bool   `json:"error"`
	AccessToken  string `json:"access_token"`
	RefreshToken string `json:"refresh_token"`
}

func main() {
	var users []User

	for i := 0; i < 10; i++ {
		user := User{
			Name:     fmt.Sprintf("Test%d", i),
			Email:    fmt.Sprintf("test%d@gmail.com", i),
			Password: "testpassword12345",
		}

		jsonBody, err := json.Marshal(user)
		if err != nil {
			fmt.Println("Error:", err)
			return
		}

		bodyReader := bytes.NewReader(jsonBody)
		res, err := http.Post("http://localhost:8080/api/v1/auth/signup", "application/json", bodyReader)

		if err != nil {
			log.Fatalln(err)
			return
		}

		defer res.Body.Close()

		body, err := ioutil.ReadAll(res.Body)
		if err != nil {
			fmt.Println("Error:", err)
			return
		}

		fmt.Printf("Created User: %s\n", string(body))

		signInUser := SignInUser{
			Email:    user.Email,
			Password: user.Password,
		}

		jsonBody, err = json.Marshal(signInUser)
		if err != nil {
			fmt.Println("Error:", err)
			return
		}

		bodyReader = bytes.NewReader(jsonBody)

		res, err = http.Post("http://localhost:8080/api/v1/auth/signin?type=email", "application/json", bodyReader)

		if err != nil {
			log.Fatalln(err)
			return
		}

		defer res.Body.Close()

		signInResByte, err := ioutil.ReadAll(res.Body)
		if err != nil {
			fmt.Println("Error:", err)
			return
		}

		var signInRes SignInResponse
		err = json.Unmarshal(signInResByte, &signInRes)
		// fmt.Println(string(signInResByte))

		if err != nil {
			fmt.Println("Failed Unmarshal Error:", err)
			return
		}

		// fmt.Println("SignIn Response:", signInRes)

		user.AccessToken = signInRes.AccessToken
		user.RefreshToken = signInRes.RefreshToken
		users = append(users, user)
		fmt.Println("Created User", user)
	}

	jsonData, err := json.Marshal(users)
	if err != nil {
		fmt.Println("Error:", err)
		return
	}

	err = ioutil.WriteFile("users.json", jsonData, 0644)

	if err != nil {
		fmt.Println("Error Writing file:", err)
		return
	}
}
