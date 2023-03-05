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
	scanResults := setupScanResultConsumer(channel)

	go func() {
		for d := range scanResults {
			log.Printf("Received a message: %s", d.Body)
			produceSaveScanRequest(channel, d.Body)
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

func setupScanResultConsumer(channel *amqp.Channel) <-chan amqp.Delivery {
	messages, err := channel.Consume(
		"SCAN_RESULT", // queue
		"",            // consumer
		true,          // auto-ack
		false,         // exclusive
		false,         // no-local
		false,         // no-wait
		nil,           // args
	)
	failOnError(err, "Failed to register a consumer")

	return messages
}

func ProduceScanRequest(channel *amqp.Channel, body []byte) {
	err := channel.Publish(
		"",             // exchange
		"SCAN_REQUEST", // routing key
		false,          // mandatory
		false,          // immediate
		amqp.Publishing{
			ContentType: "text/plain",
			Body:        body,
		})
	failOnError(err, "Failed to publish a message")

}

func produceSaveScanRequest(channel *amqp.Channel, body []byte) {
	err := channel.Publish(
		"",          // exchange
		"SAVE_SCAN", // routing key
		false,       // mandatory
		false,       // immediate
		amqp.Publishing{
			ContentType: "text/plain",
			Body:        body,
		})
	failOnError(err, "Failed to publish a message")

}
