package main

import (
	"encoding/json"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		jsonResponse(w, map[string]interface{}{
			"service": "Service 1",
			"status":  "running",
			"endpoints": []string{"/ping", "/hello", "/health"},
		})
	})

	http.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
		jsonResponse(w, map[string]interface{}{
			"status":  "ok",
			"service": "1",
		})
	})

	http.HandleFunc("/hello", func(w http.ResponseWriter, r *http.Request) {
		jsonResponse(w, map[string]interface{}{
			"message": "Hello from Service 1",
		})
	})

	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		jsonResponse(w, map[string]interface{}{
			"status":    "healthy",
			"service":   "Service 1",
			"uptime":    "running",
			"timestamp": "2025-06-25",
		})
	})

	log.Println("Service 1 listening on port 8001...")
	if err := http.ListenAndServe(":8001", nil); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}

func jsonResponse(w http.ResponseWriter, data map[string]interface{}) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(data)
}
