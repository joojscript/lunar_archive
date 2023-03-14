use crate::{
    common::services::{self, OnScanResultAction},
    services::scan::perform_scan,
};
use std::collections::BTreeMap;

use amiquip::{
    Channel, Connection, ConsumerMessage, ConsumerOptions, ExchangeDeclareOptions, ExchangeType,
    Publish, Queue, QueueDeclareOptions, Result,
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

    let save_scan_queue = channel.queue_declare(
        "SAVE_SCAN",
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

                // Save code
                if scan_request.action() == OnScanResultAction::Save {
                    publish_scan_result(
                        &channel,
                        &save_scan_queue,
                        serde_json::to_string(&scan_result).unwrap().as_bytes(),
                    )?;
                }
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

fn publish_scan_result(channel: &Channel, save_scan_queue: &Queue, payload: &[u8]) -> Result<()> {
    let exchange = channel.exchange_declare(
        ExchangeType::Direct,
        "SAVE_SCAN_EXCHANGE",
        ExchangeDeclareOptions {
            durable: true,
            ..Default::default()
        },
    )?;

    save_scan_queue.bind(&exchange, "SAVE_SCAN", BTreeMap::new())?;

    exchange.publish(Publish::new(payload, "SAVE_SCAN"))?;

    Ok(())
}
