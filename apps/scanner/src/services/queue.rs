use crate::{
    common::services::{self},
    services::scan::perform_scan,
};
use std::collections::BTreeMap;

use amiquip::{
    Channel, Connection, ConsumerMessage, ConsumerOptions, Exchange, ExchangeDeclareOptions,
    ExchangeType, Publish, Queue, QueueDeclareOptions, Result,
};

pub fn start_queue() -> Result<(Connection, Channel)> {
    // Open connection.
    let mut connection = Connection::insecure_open("amqp://admin:docker@192.168.0.114:5672")?;

    // Open a channel - None says let the library choose the channel ID.
    let channel = connection.open_channel(None)?;

    Ok((connection, channel))
}

pub fn start_queue_consumer(connection: Connection, channel: Channel) -> Result<()> {
    let scan_request_queue = channel.queue_declare(
        "SCAN_REQUEST",
        QueueDeclareOptions {
            durable: true,
            ..Default::default()
        },
    )?;

    // Start a consumer.
    let consumer = scan_request_queue.consume(ConsumerOptions {
        ..Default::default()
    })?;
    println!("Waiting for messages. Press Ctrl-C to exit.");

    for (i, message) in consumer.receiver().iter().enumerate() {
        match message {
            ConsumerMessage::Delivery(delivery) => {
                let body = String::from_utf8_lossy(&delivery.body);
                println!("({:>3}) Received [{}]", i, body);
                let scan_request: services::ScanRequest =
                    serde_json::from_slice(body.as_bytes()).unwrap();
                let scan_result = perform_scan(&scan_request).unwrap();

                publish_scan_result(
                    &channel,
                    serde_json::to_string(&scan_result).unwrap().as_bytes(),
                )?;
                consumer.ack(delivery)?;
            }
            other => {
                println!("Consumer ended: {:?}", other);
                break;
            }
        }
    }

    connection.close()?;

    Ok(())
}

fn publish_scan_result(channel: &Channel, payload: &[u8]) -> Result<()> {
    let exchange = Exchange::direct(channel);

    exchange.publish(Publish::new(payload, "SCAN_RESULT"))?;

    Ok(())
}
