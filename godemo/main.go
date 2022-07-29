package main

import (
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var db *gorm.DB

const dsn = "host=pg-postgresql.default.svc.cluster.local user=postgres password=Ok7iOqHYnk dbname=test port=5432"

type TodoItem struct {
	Id        string
	Text      string
	Completed bool
}

func main() {
	d, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		panic(err)
	}
	db = d

	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		db.Create(&TodoItem{
			Id:        uuid.New().String(),
			Text:      "aaa",
			Completed: false,
		})
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})
	r.Run() // listen and serve on 0.0.0.0:8080
}
