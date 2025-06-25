FROM golang:1.20-alpine
RUN apk add --no-cache curl
WORKDIR /app
COPY . .
RUN go build -o main .
CMD ["./main"]
