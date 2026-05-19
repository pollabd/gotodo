package main

import (
	"gotodo/internal/config"
	"gotodo/internal/database"
	"log"

	"github.com/gin-gonic/gin"
)

func main() {

	// var cfg *config.Config
	// var err error

	cfg, err := config.Load()
	if err != nil {
		log.Fatal("Failed to load configuration", err)
	}

	pool, err := database.Connect(cfg.DatabaseUrl)
	if err != nil {
		log.Fatal("Failed to connect to the database", err)
	}
	defer pool.Close()

	var router *gin.Engine = gin.Default()
	router.SetTrustedProxies(nil)
	router.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status":   "success",
			"message":  "Todo api is running",
			"database": "connected",
		})
	})

	router.Run(":" + cfg.Port)
}
