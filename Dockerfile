##
## Build
##

FROM golang:1.16-buster AS build

WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY *.go ./

RUN go build -o /gs-ping-db

##
## Deploy
##

FROM gcr.io/distroless/base-debian10

WORKDIR /

COPY --from=build /gs-ping-db /gs-ping-db

EXPOSE 8080

USER nonroot:nonroot

ENTRYPOINT ["/gs-ping-db"]
