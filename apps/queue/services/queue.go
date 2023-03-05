package services

import (
	"fmt"
	"log"

	amqp "github.com/rabbitmq/amqp091-go"
)

func SetupQueue() (*amqp.Connection, *amqp.Channel) {
	connection, err := amqp.Dial("amqp://admin:docker@192.168.0.114:5672/")

	if err != nil {
		panic(fmt.Sprintf(
			"Error trying to connect to RabbitMQ: %s", err,
		))
	}

	channel, err := connection.Channel()
	failOnError(err, "Failed to open a channel")

	setupQueues(channel)
	scanRequests := setupScanRequestConsumer(channel)

	go func() {
		for d := range scanRequests {
			log.Printf("Received a message: %s", d.Body)
			produceScanResult(channel, d.Body)
		}
	}()

	return connection, channel
}

func failOnError(err error, msg string) {
	if err != nil {
		log.Panicf("[RABBIT MQ] %s: %s", msg, err)
	}
}

func setupQueues(channel *amqp.Channel) {
	queueBlueprints := []string{"SCAN_REQUEST", "SCAN_RESULT"}
	queues := []amqp.Queue{}

	for _, queueBlueprint := range queueBlueprints {
		queue, err := channel.QueueDeclare(
			queueBlueprint, // name
			true,           // durable
			false,          // delete when unused
			false,          // exclusive
			false,          // no-wait
			nil,            // arguments
		)
		queues = append(queues, queue)
		failOnError(err, "Failed to declare a queue")
	}
}

func setupScanRequestConsumer(channel *amqp.Channel) <-chan amqp.Delivery {
	messages, err := channel.Consume(
		"SCAN_REQUEST", // queue
		"",             // consumer
		true,           // auto-ack
		false,          // exclusive
		false,          // no-local
		false,          // no-wait
		nil,            // args
	)
	failOnError(err, "Failed to register a consumer")

	return messages
}

func produceScanResult(channel *amqp.Channel, body []byte) {
	err := channel.Publish(
		"",            // exchange
		"SCAN_RESULT", // routing key
		false,         // mandatory
		false,         // immediate
		amqp.Publishing{
			ContentType: "text/plain",
			Body:        body,
		})
	failOnError(err, "Failed to publish a message")

}
