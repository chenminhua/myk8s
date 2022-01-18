package main

import (
	"context"
	"time"

	"github.com/go-redis/redis/v8"
)

var (
	rdb *redis.ClusterClient
)

var ctx = context.Background()

func main() {
	rdb = redis.NewClusterClient(&redis.ClusterOptions{
		Addrs:    []string{"rc-redis-cluster:6379"},
		Password: "m2S28sp8tX", // no password set
	})
	keys := []string{"a", "b", "c"}
	for {
		for _, k := range keys {
			incr(k)
		}
		time.Sleep(100 * time.Millisecond)
	}

}

func incr(key string) {
	res, err := rdb.Incr(ctx, key).Result()
	if err != nil {
		println("errrr ", err.Error())
	}
	println(res)
}
