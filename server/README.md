# QFT Movies and Booking API Server

##### Features

* List movies ( upcoming, as well as now showing )
* Book and purchase tickets with [Stripe payments](https://stripe.com/).
    * Download and view tickets with QR Code.
    * Booked Seats has expiry time of 15 mins.
* Add movie for screening
* Add cinema, auditoriums and customize auditorium seat layouts.

#### Requirements
- [Golang](https://go.dev/)

#### Libraries
- [Gin](https://gin-gonic.com) - Go Web Framework
- [GORM](https://gorm.io) - ORM library
- [Uber-Fx](https://github.com/uber-go/fx) - Dependency Injection Framework

### Usage :
Copy `sample.env` file as `.env` in the root directory and edit all the values.
___

### **Debug build**

Runs server without building
``` console
user@main:~$ go run main.go
```
Build and run server
``` console
user@main:~$ go build -o main main.go
user@main:~$ ./main
```
___
#### Release build
``` console
user@main:~$ go build -o main main.go
user@main:~$ GIN_MODE=release ./main
```
After running the commands, Authentication server runs on port `8080` or port specifiend in `.env` or environment.