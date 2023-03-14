package services

import (
	"encoding/json"
	amqp "github.com/rabbitmq/amqp091-go"
	"github.com/robfig/cron/v3"
)

func SetupCron(channel *amqp.Channel) *cron.Cron {
	c := cron.New()
	c.AddFunc("* * * * *", func() {
		payload, err := json.Marshal(ScanRequest{
			Hostname: "192.168.0.114",
			Ports:    []string{"80", "90-199/udp"},
			Action:   OnScanResultAction_SAVE,
		})

		if err != nil {
			panic(err)
		}

		ProduceScanRequest(channel, []byte(payload))
	})
	c.Start()
	return c
}
