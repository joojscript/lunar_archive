package services

import (
	"fmt"

	"github.com/robfig/cron/v3"
)

func SetupCron() *cron.Cron {
	c := cron.New()
	c.AddFunc("* * * * *", func() { fmt.Println("[PLACEHOLDER] Running cron callback") })
	c.Start()
	return c
}
