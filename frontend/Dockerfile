# A named stage: "build"
FROM golang:1.22 AS builder
 
WORKDIR /src
COPY go.* ./
RUN go mod download
 
COPY . ./
RUN CGO_ENABLED=0 go build -o /bin/app

# A new stage: "run"
FROM gcr.io/distroless/static-debian12:nonroot AS run
#FROM debian:stable-slim AS run

# Copy the binary from stage build
WORKDIR /app
COPY --from=builder /bin/app ./app
COPY --chown=nonroot:nonroot web ./web
 
ENTRYPOINT ["./app"]
