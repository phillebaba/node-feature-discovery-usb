package main

import (
	"fmt"
	"log"

	"github.com/google/gousb"
)

func main() {
	ctx := gousb.NewContext()
	defer ctx.Close()

	devs, err := ctx.OpenDevices(func(desc *gousb.DeviceDesc) bool {
		fmt.Printf("%s_%s.present\n", desc.Vendor, desc.Product)
		return false
	})

	defer func() {
		for _, d := range devs {
			d.Close()
		}
	}()

	if err != nil {
		log.Fatalf("list: %s", err)
	}
}
