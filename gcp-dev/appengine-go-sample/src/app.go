package main

import (
	"log"

	_ "handlers"

	"google.golang.org/appengine"
)

func main() {
	log.Print("Starting app engine")
	appengine.Main()
}
