mod common;
mod generated;
mod services;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let (queue_connection, queue_channel) = services::queue::start_queue()?;
    services::queue::start_queue_consumer(queue_connection, queue_channel)?;
    Ok(())
}
