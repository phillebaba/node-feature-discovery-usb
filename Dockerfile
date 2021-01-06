FROM golang:1.15-alpine as builder
WORKDIR /workspace
RUN apk add libusb-dev build-base
COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download
COPY main.go main.go
RUN go build -a -o usb main.go

FROM k8s.gcr.io/nfd/node-feature-discovery:v0.7.0
LABEL org.opencontainers.image.source="https://github.com/phillebaba/node-feature-discovery-usb"
USER root
RUN apt update && apt install libusb-1.0-0
COPY --from=builder /workspace/usb /etc/kubernetes/node-feature-discovery/source.d/usb
