package main

import (
	"log"
	"net/http"
	"os"
	"strings"
)

func main() {
	http.Handle("/", http.FileServer(http.Dir("./")))
	port := strings.Join([]string{":", os.Getenv("PORT")}, "")

	err := http.ListenAndServe(port, nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
