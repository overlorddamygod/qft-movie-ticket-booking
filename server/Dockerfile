# STEP 1 build executable binary
FROM golang:alpine AS builder

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

RUN apk update && apk add --no-cache git

WORKDIR /app

COPY . .

# RUN go mod download

RUN go build -o main main.go

# STEP 2 build a small image
FROM scratch

COPY --from=builder /app/main /app/main

EXPOSE 8080

ENTRYPOINT ["/app/main"]