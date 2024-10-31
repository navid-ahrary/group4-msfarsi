// main.go
package main

import (
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/go-ping/ping"
)

type RequestBody struct {
	URL      string `json:"url"`
	Protocol string `json:"protocol"`
}

func main() {
	r := gin.Default()

	// Serve static files from the "public" directory
	r.Static("/public", "./public")

	// Serve index.html when accessing the root URL
	r.GET("/", func(c *gin.Context) {
		c.File("./public/index.html")
	})

	// POST /request API endpoint
	r.POST("/request", func(c *gin.Context) {
		var requestBody RequestBody

		// Bind JSON request body to struct
		if err := c.ShouldBindJSON(&requestBody); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"statusCode": 400, "message": "Invalid request body"})
			return
		}

		// Validate that the URL or IP address is provided
		url := requestBody.URL
		protocol := strings.ToLower(requestBody.Protocol)
		if url == "" || protocol == "" {
			c.JSON(http.StatusBadRequest, gin.H{"statusCode": 400, "message": "URL and protocol are required"})
			return
		}

		// Handle requests based on the protocol
		var statusCode int
		var err error
		switch protocol {
		case "icmp":
			statusCode, err = checkICMP(url)
		case "http", "https", "ftp", "udp", "tcp":
			statusCode, err = checkHTTP(url, protocol)
		default:
			c.JSON(http.StatusBadRequest, gin.H{"statusCode": 400, "message": "Unsupported protocol"})
			return
		}

		if err != nil {
			c.JSON(http.StatusForbidden, gin.H{"statusCode": statusCode, "message": err.Error()})
		} else {
			c.JSON(http.StatusOK, gin.H{"statusCode": statusCode, "message": "Success"})
		}
	})

	// Start the server
	if err := r.Run(":8080"); err != nil {
		panic(err)
	}
}

// checkHTTP sends an HTTP/HTTPS/FTP/URD/TCP request to the specified URL
func checkHTTP(url, protocol string) (int, error) {
	fullURL := url
	if !strings.HasPrefix(url, "http") && protocol != "tcp" {
		fullURL = protocol + "://" + url
	}

	client := http.Client{
		Timeout: 5 * time.Second,
	}
	resp, err := client.Head(fullURL)
	if err != nil {
		return http.StatusForbidden, err
	}
	defer resp.Body.Close()

	return resp.StatusCode, nil
}

// checkICMP performs a ping to check ICMP reachability
func checkICMP(url string) (int, error) {
	pinger, err := ping.NewPinger(url)
	if err != nil {
		return http.StatusForbidden, fmt.Errorf("ICMP error: %v", err)
	}
	pinger.Count = 3
	pinger.Timeout = 5 * time.Second

	err = pinger.Run()
	if err != nil || pinger.Statistics().PacketsRecv == 0 {
		return http.StatusForbidden, fmt.Errorf("host not reachable via ICMP")
	}

	return http.StatusOK, nil
}
