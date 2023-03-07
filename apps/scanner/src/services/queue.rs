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
                publish_scan_result(&channel, &save_scan_queue)?;
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

fn publish_scan_result(channel: &Channel, save_scan_queue: &Queue) -> Result<()> {
    let exchange = channel.exchange_declare(
        ExchangeType::Direct,
        "SAVE_SCAN_EXCHANGE",
        ExchangeDeclareOptions {
            durable: true,
            ..Default::default()
        },
    )?;

    save_scan_queue.bind(&exchange, "SAVE_SCAN", BTreeMap::new())?;

    exchange.publish(Publish::new("Hello, world!".as_bytes(), "SAVE_SCAN"))?;

    Ok(())
}
