package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
)

func pong(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "pong")
}

func main() {
	http.HandleFunc("/ping", pong)

	http.Handle("/", http.FileServer(http.Dir("./")))
	port := strings.Join([]string{":", os.Getenv("PORT")}, "")

	err := http.ListenAndServe(port, nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
