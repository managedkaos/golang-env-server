FROM golang:1.13-alpine AS builder
#FROM 264318998405.dkr.ecr.us-west-2.amazonaws.com/golang:1.13-alpine AS builder
RUN apk --update add ca-certificates git make g++
#ENV GO111MODULE=on
WORKDIR /app
COPY . .
ARG COMMIT_HASH
ENV COMMIT_HASH=${COMMIT_HASH}
ARG BUILD_DATE
ENV BUILD_DATE=${BUILD_DATE}
RUN go get -u pack.ag/amqp && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o app
FROM golang:1.13-alpine
#FROM 264318998405.dkr.ecr.us-west-2.amazonaws.com/golang:1.13-alpine
WORKDIR /app
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
RUN true
COPY --from=builder /app/app .
EXPOSE 8080
CMD [ "./app" ]
