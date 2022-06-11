# QFT USAGE

### Using Docker
```bash
user@main:~$ cd docker
// Copy `sample.env` file as `.env` in the root directory and edit all the values.
user@main:~$ docker compose up
```

## Client App

### Getting Started

Go to `./client` directory.

Copy `sample.env` file as `.env` in the root directory and edit all the values.

First, run the development server:

```bash
user@main:~$ npm run dev
# or
user@main:~$ yarn dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

Build the app
```bash
user@main:~$ npm run build
user@main:~$ npm run start
```

Or use make file in the root directory.

**More docs on `README.md` file of the client directory.**

---

## QFT API Server

### Getting Started

Go to `./server` directory.

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

Or use make file in the root directory.

**More docs on `README.md` file of the server directory.**
