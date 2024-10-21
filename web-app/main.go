// main.go
package main

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// Serve static files from the "public" directory
	r.Static("/public", "./public")

	// Serve index.html when accessing the root URL
	r.GET("/", func(c *gin.Context) {
		c.File("./public/index.html") // Make sure index.html is in the public directory
	})

	// POST /request API endpoint
	r.POST("/request", func(c *gin.Context) {
		var requestBody struct {
			URL string `json:"url"`
		}

		// Bind JSON request body to struct
		if err := c.ShouldBindJSON(&requestBody); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"statusCode": 400, "message": "Invalid request body"})
			return
		}

		// Validate that the URL or IP address is provided
		url := requestBody.URL
		if url == "" {
			c.JSON(http.StatusBadRequest, gin.H{"statusCode": 400, "message": "URL or IP address is required"})
			return
		}

		// Prepend "https://" if the input is not already a valid URL
		fullURL := url
		if !isValidURL(url) {
			fullURL = "https://" + url
		}

		client := http.Client{
			Timeout: 5 * time.Second, // Set timeout
		}

		// Make the HTTP request to the provided URL
		resp, err := client.Head(fullURL)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"statusCode": 500, "message": err.Error()})
			return
		}
		defer resp.Body.Close()

		c.JSON(http.StatusOK, gin.H{"statusCode": resp.StatusCode})
	})

	// Start the server
	if err := r.Run(":8080"); err != nil {
		panic(err)
	}
}

// isValidURL checks if a string is a valid URL
func isValidURL(url string) bool {
	return len(url) > 0 && (url[:4] == "http" || url[:5] == "https")
}
