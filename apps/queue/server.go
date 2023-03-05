package main

import (
	"log"
	"lunar/services"
	"sync"
)

func main() {
	wg := sync.WaitGroup{}
	wg.Add(1)

	queueConnection, queueChannel := services.SetupQueue()
	cron := services.SetupCron(queueChannel)

	defer cron.Stop() // Stop the scheduler (does not stop any jobs already running).
	defer queueChannel.Close()
	defer queueConnection.Close()

	var forever chan struct{}
	log.Printf(" [*] Waiting for messages. To exit press CTRL+C")
	<-forever

	wg.Wait()
}
