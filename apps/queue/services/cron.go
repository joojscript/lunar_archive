package services

import (
	"strings"

	amqp "github.com/rabbitmq/amqp091-go"
	"github.com/robfig/cron/v3"
)

func SetupCron(channel *amqp.Channel) *cron.Cron {
	c := cron.New()
	c.AddFunc("* * * * *", func() {
		ProduceScanRequest(channel, []byte(strings.Join([]string{"80", "90-199/udp"}, ",")))
	})
	c.Start()
	return c
}
