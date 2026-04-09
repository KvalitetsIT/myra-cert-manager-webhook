FROM golang:1.25 AS builder
WORKDIR /usr/src/app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags="-s -w" -o /app ./cmd/app/main.go

FROM scratch
WORKDIR /app
COPY --from=builder /app /app/app
USER 65532:65532
ENTRYPOINT ["/app/app"]
