FROM golang:1.13.2-buster AS build

RUN apt update && apt install -y libusb-1.0-0-dev
RUN go get github.com/golang/dep/cmd/dep

COPY Gopkg.lock Gopkg.toml /go/src/github.com/phillebaba/node-feature-discovery-usb/
WORKDIR /go/src/github.com/phillebaba/node-feature-discovery-usb
RUN dep ensure -vendor-only

COPY . /go/src/github.com/phillebaba/node-feature-discovery-usb
RUN go build -o /bin/usb main.go

FROM phillebaba/node-feature-discovery:v0.4.0
RUN apt update && apt install libusb-1.0-0
COPY --from=build /bin/usb /etc/kubernetes/node-feature-discovery/source.d/usb
