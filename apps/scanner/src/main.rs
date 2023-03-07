use services::scan::parse_ports;

tonic::include_proto!("services.scan");

mod services;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let ports = vec![
        "80",
        "443",
        "8080/tcp",
        "8080/udp",
        "8080-8081/tcp",
        "8080-8081/udp",
    ];

    parse_ports(ports)?;

    Ok(())

    // let (queue_connection, queue_channel) = services::queue::start_queue()?;
    // services::queue::start_queue_consumer(queue_connection, queue_channel)?;
    // Ok(())
}
